import fastifyPlugin from "fastify-plugin";
import memberServicePlugin from "../services/memberService.js";

import Passwordless from "supertokens-node/recipe/passwordless/index.js";
import { verifySession } from "supertokens-node/recipe/session/framework/fastify/index.js";
import st from "supertokens-node/framework/fastify/index.js";
const { SessionRequest } = st;

async function memberRoutes(server, options) {
  server.register(memberServicePlugin);

  server.get(
    "/member/accounts",
    {
      preHandler: verifySession(),
      schema: {
        description: "Returns accounts the member can access",
        tags: ["member"],
        response: {
          200: {
            description: "Success Response",
            type: "object",
            properties: {
              accounts: { type: "array" },
            },
          },
        },
      },
    },
    async (request, reply) => {
      let userId = request.session.getUserId();

      console.log("MEMBER ACCOUNTS");

      const accounts = await server.accountService.getMemberAccounts(userId);

      return {
        accounts: accounts,
      };
    }
  );
}

export default fastifyPlugin(memberRoutes);
