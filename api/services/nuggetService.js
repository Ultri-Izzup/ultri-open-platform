import fp from "fastify-plugin";

const NuggetService = (postgres) => {
  console.log("NuggetService", postgres);

  const getMemberNuggets = async (member_uid, nugget_type) => {
    const client = await postgres.connect();

    try {
      const {
        rows,
      } = await client.query('SELECT uid,"createdAt","updatedAt","pubAt","unPubAt","publicTitle","internalName","nuggetType" FROM izzup_api.member_nuggets($1, $2)', [
        member_uid,
        nugget_type,
      ]);

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

    if(nuggetData.accountId) {

      query = `SELECT uid, created_at
        FROM izzup_api.create_account_nugget(
          $1, $2, $3, $4, $5
      )`;

      values = [
        nuggetData.public_title,
        nuggetData.internal_name,
        nuggetData.nugget_type,
        nuggetData.account_id,
        authMemberId
      ];



    } else {

      query = `SELECT uid, created_at 
        FROM izzup_api.create_member_nugget(
          $1, $2, $3, $4
      )`;

      values = [
        nuggetData.public_title,
        nuggetData.internal_name,
        nuggetData.nugget_type,
        authMemberId
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
