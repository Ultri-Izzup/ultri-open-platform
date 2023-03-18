import fp from "fastify-plugin";

const NuggetService = (postgres) => {
  console.log("NuggetService", postgres);

  const memberNuggets = async (member_uid, nugget_type) => {
    const client = await postgres.connect();

    try {
      const { rows } = await client.query(
        "SELECT * FROM izzup_api.member_nuggets($1, $2)", [member_uid, nugget_type]
      );

      // Note: avoid doing expensive computation here, this will block releasing the client
      return rows;
    } finally {
      // Release the client immediately after query resolves, or upon error
      client.release();
    }
  };

  return { memberNuggets };
};

export default fp((server, options, next) => {
  server.decorate("nuggetService", NuggetService(server.pg));
  next();
});
