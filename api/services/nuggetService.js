import fp from "fastify-plugin";

const NuggetService = (postgres) => {
  console.log("NuggetService", postgres);

  const getMemberNuggets = async (member_uid, nugget_type) => {
    const client = await postgres.connect();

    try {
      const {
        rows,
      } = await client.query("SELECT * FROM izzup_api.member_nuggets($1, $2)", [
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

    const query = `INSERT INTO izzup_api.nugget(
                    public_title, 
                    internal_name, 
                    account_id, 
                    nugget_type_id) 
                VALUES (
                    $1, 
                    $2, 
                    izzup_api.get_member_account($3), 
                    izzup_api.get_nugget_type_id($4,$5))`;

    const values = [
      nuggetData.public_title,
      nuggetData.internal_name,
      authMemberId,
      nuggetData.nugget_type,
      null
    ];

    try {
      const { rows } = await client.query(query, values);

      // Note: avoid doing expensive computation here, this will block releasing the client
      return rows;
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
