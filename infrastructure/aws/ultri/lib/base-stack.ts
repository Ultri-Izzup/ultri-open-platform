import { Stack, StackProps } from "aws-cdk-lib";
import { Construct } from "constructs";
import {
  aws_ec2 as ec2,
  aws_route53 as route53,
  aws_elasticache as elasticache,
  aws_rds as rds
} from 'aws-cdk-lib';
import {readFileSync} from 'fs';
import * as cdk from "aws-cdk-lib";
import { Aspects, CfnOutput, Duration } from 'aws-cdk-lib';
import { CfnDBCluster } from 'aws-cdk-lib/aws-rds';

const stackName = "UltriStack";

export class BaseStack extends cdk.Stack {
 
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    const vpc = new ec2.Vpc(this, `${stackName}Vpc`, {
      maxAzs: 2,
      ipAddresses: ec2.IpAddresses.cidr('172.27.0.0/16'),
      natGateways: 0,
      subnetConfiguration: [
        {
          name: `${stackName}PublicSubnet`,
          subnetType: ec2.SubnetType.PUBLIC,
        },
        {
          name: `${stackName}IsolatedSubnet`,
          subnetType: ec2.SubnetType.PRIVATE_ISOLATED,
        },
        {
          name: `${stackName}PrivateSubnet`,
          subnetType: ec2.SubnetType.PRIVATE_WITH_EGRESS
        },
      ],
    });

    cdk.Tags.of(vpc).add('copilot-application', 'ultri');
    cdk.Tags.of(vpc).add('copilot-environment', 'production');
    cdk.Tags.of(vpc).add('ultri-tenant', 'ultri');
    cdk.Tags.of(vpc).add('ultri-cost-center', 'service-infrastructure');

    const redisSubnetGroup = new elasticache.CfnSubnetGroup(
      this,
      `${stackName}redisSubnetGroup`,
      {
        description: "Subnet group for the redis cluster",
        subnetIds: vpc.publicSubnets.map((ps) => ps.subnetId),
        cacheSubnetGroupName: "Ultri-Redis-Subnet-Group",
      }
    );

    const redisSecurityGroup = new ec2.SecurityGroup(
      this,
      `${stackName}RedisSecurityGroup`,
      {
        vpc: vpc,
        allowAllOutbound: true,
        description: "Security group for the redis cluster",
      }
    );

    const redisCache = new elasticache.CfnCacheCluster(
      this,
      `${stackName}RedisCache`,
      {
        engine: "redis",
        cacheNodeType: "cache.t3.micro",
        numCacheNodes: 1,
        clusterName: "Ultri-Redis-Cluster",
        vpcSecurityGroupIds: [redisSecurityGroup.securityGroupId],
        cacheSubnetGroupName: redisSubnetGroup.ref,
        engineVersion: "6.2",
        preferredMaintenanceWindow: "fri:00:30-fri:01:30",
      }
    );
    
    redisCache.addDependency(redisSubnetGroup);

    cdk.Tags.of(redisCache).add('copilot-application', 'ultri');
    cdk.Tags.of(redisCache).add('copilot-environment', 'production');
    cdk.Tags.of(redisCache).add('ultri-tenant', 'ultri');
    cdk.Tags.of(redisCache).add('ultri-cost-center', 'service-infrastructure');
    
    
    new cdk.CfnOutput(this, `${stackName}CacheEndpointUrl`, {
      value: redisCache.attrRedisEndpointAddress,
    });

    new cdk.CfnOutput(this, `${stackName}CachePort`, {
      value: redisCache.attrRedisEndpointPort,
    });

    const ec2SG = new ec2.SecurityGroup(this, `${stackName}Ec2SG`, {
      vpc: vpc,
      allowAllOutbound: true,
      securityGroupName: "Docker Host Security Group",
    });

    ec2SG.connections.allowTo(
      redisSecurityGroup,
      ec2.Port.tcp(6379),
      "Allow ec2 connections to the redis cache"
    );

    ec2SG.addIngressRule(
      ec2.Peer.ipv4('174.87.2.136/32'),
      ec2.Port.tcp(22),
      'allow SSH connections from office',
    );

    ec2SG.addIngressRule(
      ec2.Peer.anyIpv4(),
      ec2.Port.tcp(80),
      'allow HTTP connections from anywhere',
    );

    ec2SG.addIngressRule(
      ec2.Peer.anyIpv4(),
      ec2.Port.tcp(443),
      'allow HTTPS connections from anywhere',
    );

    const rootVolume: ec2.BlockDevice = {
      deviceName: '/dev/sda1', 
      volume: ec2.BlockDeviceVolume.ebs(40), // Override the volume size in Gibibytes (GiB)
    };

    // 👇 create the EC2 instance
    const ec2Instance = new ec2.Instance(this, 'ec2-instance', {
      vpc,
      vpcSubnets: {
        subnetType: ec2.SubnetType.PUBLIC,
      },
      securityGroup: ec2SG,
      instanceType: ec2.InstanceType.of(
        ec2.InstanceClass.T3,  // One 't4g.small' per account free through end of 2023
        ec2.InstanceSize.MEDIUM
      ),
      // Images from https://wiki.debian.org/Cloud/AmazonEC2Image/Bullseye
      machineImage: new ec2.GenericLinuxImage({
        'us-east-1': 'ami-0fec2c2e2017f4e7b',
        'us-west-1': 'ami-0bf166b48bbe2bf7c'
      }),
      keyName: 'dell-laptop',
      blockDevices: [rootVolume]
    });

    // 👇 load user data script
    const userDataScript = readFileSync('./lib/user-data.sh', 'utf8');

    // 👇 add user data to the EC2 instance
    ec2Instance.addUserData(userDataScript);

    cdk.Tags.of(ec2Instance).add('ultri-tenant', 'ultri');
    cdk.Tags.of(ec2Instance).add('ultri-cost-center', 'service-infrastructure');
    cdk.Tags.of(ec2Instance).add('Name', 'Service-US-East-1-Compute-x86-1');

    // Elastic IP
    let eip = new ec2.CfnEIP(this, "Ip");

    // EC2 Instance <> EIP
    let ec2Assoc = new ec2.CfnEIPAssociation(this, "Ec2Association", {
      eip: eip.ref,
      instanceId: ec2Instance.instanceId
    });

    const hostedZone = route53.HostedZone.fromLookup(this, "HostedZone", {
      domainName: 'ultri.com',
    });

    new route53.ARecord(this, 'ServiceARecord', {
      zone: hostedZone,
      target: route53.RecordTarget.fromIpAddresses(eip.ref),
      recordName: 'service.ultri.com'
    });
    new route53.ARecord(this, 'AuthARecord', {
      zone: hostedZone,
      target: route53.RecordTarget.fromIpAddresses(eip.ref),
      recordName: 'auth.ultri.com'
    });
    new route53.ARecord(this, 'SpecificHostARecord', {
      zone: hostedZone,
      target: route53.RecordTarget.fromIpAddresses(eip.ref),
      recordName: 'host-0.service.ultri.com'
    });
    

    const postgresCluster = new rds.DatabaseCluster(this, 'db-cluster', {
      engine: rds.DatabaseClusterEngine.auroraPostgres({
        version: rds.AuroraPostgresEngineVersion.VER_14_5,
      }),
      instances: 1,
      instanceProps: {
        vpc: vpc,
        instanceType: new ec2.InstanceType('serverless'),
        autoMinorVersionUpgrade: true,
        publiclyAccessible: false,
        deleteAutomatedBackups: true,
        vpcSubnets: vpc.selectSubnets({
          subnetType: ec2.SubnetType.PRIVATE_ISOLATED, 
        }),
      },
      credentials: rds.Credentials.fromGeneratedSecret('postgres', {secretName: 'ultri/ultri/production/postgres-cluster',}),
      port: 5432,
      deletionProtection: false,      
    })
    
    // add capacity to the db cluster to enable scaling
    Aspects.of(postgresCluster).add({
      visit(node) {
        if (node instanceof CfnDBCluster) {
          node.serverlessV2ScalingConfiguration = {
            minCapacity: 0.5, // min capacity is 0.5 vCPU
            maxCapacity: 1, // max capacity is 1 vCPU (default)
          }
        }
      },
    })
    cdk.Tags.of(postgresCluster).add('copilot-application', 'ultri');
    cdk.Tags.of(postgresCluster).add('copilot-environment', 'production');
    cdk.Tags.of(postgresCluster).add('ultri-tenant', 'ultri');
    cdk.Tags.of(postgresCluster).add('ultri-cost-center', 'service-infrastructure');

    postgresCluster.connections.allowFrom(ec2SG, ec2.Port.tcp(5432));

    new cdk.CfnOutput(this, 'postgresClusterEndpoint', {
      value: postgresCluster.clusterEndpoint.hostname,
    });

    new cdk.CfnOutput(this, 'postgresClusterSecretName', {
      // eslint-disable-next-line @typescript-eslint/no-non-null-asserted-optional-chain
      value: postgresCluster.secret?.secretName!,
    });
  
  }
}
