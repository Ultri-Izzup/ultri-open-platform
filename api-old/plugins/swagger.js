import fp from "fastify-plugin";

import swagger from "@fastify/swagger"
import swaggerUi from '@fastify/swagger-ui';

export default fp(async function(server, opts, done) {
  await server.register(swagger);

  await server.register(swaggerUi, {
    routePrefix: '/documentation',
    stripBasePath: false,
    swagger: {
        info: {
          title: 'Ultri Open Platform API',
          description: 'Open Platform API used for Izzup.com',
          version: '0.1.0'
        },
        host: 'service.ultri.com',
        schemes: ['https','http'],
        consumes: ['application/json'],
        produces: ['application/json'],
        
      },

    uiConfig: {
      docExpansion: 'full',
      deepLinking: false 
    },
    uiHooks: {
      onRequest: function (request, reply, next) { next() },
      preHandler: function (request, reply, next) { next() }
    },
    staticCSP: true,
    transformStaticCSP: (header) => header,
    transformSpecification: (swaggerObject, request, reply) => { return swaggerObject },
    transformSpecificationClone: true
  })
})
