import fp from "fastify-plugin";

const AccountService = (postgres) => {
  console.log("AccountService", postgres);

  const getMemberAccounts = async (member_uid) => {
    const client = await postgres.connect();

    try {
      const {
        rows,
      } = await client.query(
        ` SELECT *
        FROM izzup_api.member_accounts
               WHERE "memberUid" = $1`,
        [member_uid]
      );

      // Note: avoid doing expensive computation here, this will block releasing the client
      return rows;
    } finally {
      // Release the client immediately after query resolves, or upon error
      client.release();
    }
  };

  const createAccount = async (accountData, authMemberId) => {
    const client = await postgres.connect();

    let query;
    let values;

    query = `SELECT uid, created_at
        FROM izzup_api.create_account(
          $1, $2
      )`;

    values = [accountData.name, authMemberId];

    try {
      const result = await client.query(query, values);

      const newData = result.rows[0];

      // Note: avoid doing expensive computation here, this will block releasing the client
      return {
        uid: newData.uid,
        createdAt: newData.created_at,
        name: accountData.name
      };
    } finally {
      // Release the client immediately after query resolves, or upon error
      client.release();
    }
  };

  return { getMemberAccounts, createAccount };
};

export default fp((server, options, next) => {
  server.decorate("accountService", AccountService(server.pg));
  next();
});
