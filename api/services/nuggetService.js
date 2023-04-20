import fp from "fastify-plugin";

const NuggetService = (postgres) => {
  console.log("NuggetService", postgres);

  const getMemberNuggets = async (memberUid, nuggetType) => {
    const client = await postgres.connect();

    try {
      const {
        rows,
      } = await client.query('SELECT "nuggetUid","createdAt","updatedAt","pubAt","unPubAt","publicTitle","internalName","nuggetType" FROM izzup_api.get_member_nuggets_by_type($1, $2)', [
        memberUid,
        nuggetType,
      ]);

      // Note: avoid doing expensive computation here, this will block releasing the client
      return rows;
    } finally {
      // Release the client immediately after query resolves, or upon error
      client.release();
    }
  };

  const getNugget = async (memberUid, nuggetType) => {
    const client = await postgres.connect();

    try {
      const {
        rows,
      } = await client.query('SELECT "nuggetUid","createdAt","updatedAt","pubAt","unPubAt","publicTitle","internalName","nuggetType" FROM izzup_api.get_member_nuggets_by_type($1, $2)', [
        memberUid,
        nuggetType,
      ]);

      /*
      SELECT *, permissions->>'nuggets' as nug_perm
      FROM izzup_api.member_permissions mp
      -- WHERE mp.permissions @> '{"nuggets": "all"}'
      -- WHERE mp.permissions->>'nuggets' = 'all'
      -- WHERE mp.permissions->'nuggets'->>'article' = '["c", "r", "u", "d", "pub"]'
      -- WHERE mp.permissions @> '{"nuggets":{"article": ["c", "r", "u", "d", "pub"]}}';
      WHERE mp.permissions @> '{"all": "all"}'
      OR mp.permissions @> '{"nuggets": "all"}'
      OR mp.permissions @> '{"nuggets":{"article": ["r"]}}' ;
      */

      // Note: avoid doing expensive computation here, this will block releasing the client
      return rows;
    } finally {
      // Release the client immediately after query resolves, or upon error
      client.release();
    }
  };

  const createNugget = async (nuggetData, authMemberId) => {
    const client = await postgres.connect();

    let query;
    let values;

    if(nuggetData.accountUid) {

      query = `SELECT uid, created_at
        FROM izzup_api.create_account_nugget(
          $1, $2, $3, $4, $5
      )`;

      values = [
        nuggetData.publictTitle,
        nuggetData.internalName,
        nuggetData.nuggetType,
        nuggetData.accountUid,
        authMemberId
      ];



    } else {

      query = `SELECT uid, created_at 
        FROM izzup_api.create_member_nugget(
          $1, $2, $3, $4, $5
      )`;

      console.log(nuggetData.blocks)

      values = [
        nuggetData.publicTitle,
        nuggetData.internalName,
        nuggetData.nuggetType,
        authMemberId,
        JSON.stringify(nuggetData.blocks)
      ];

    }



    try {
      const result = await client.query(query, values);

      const newData = result.rows[0];

      // Note: avoid doing expensive computation here, this will block releasing the client
      return {
        uid: newData.uid, 
        createdAt: newData.created_at,
        publicTitle: nuggetData.public_title,
        internalName: nuggetData.internal_name,
        nuggetType: nuggetData.nugget_type,
        accountId: nuggetData.account_id
      }

    } finally {
      // Release the client immediately after query resolves, or upon error
      client.release();
    }
  };

  return { getMemberNuggets, createNugget };
};



export default fp((server, options, next) => {
  server.decorate("nuggetService", NuggetService(server.pg));
  next();
});
