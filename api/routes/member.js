import fastifyPlugin from "fastify-plugin";
import memberServicePlugin from "../services/memberService.js";
import nuggetServicePlugin from "../services/nuggetService.js";

import Passwordless from "supertokens-node/recipe/passwordless/index.js";
import { verifySession } from "supertokens-node/recipe/session/framework/fastify/index.js";
import st from "supertokens-node/framework/fastify/index.js";
const { SessionRequest } = st;

async function memberRoutes(server, options) {
  server.register(memberServicePlugin);
  server.register(nuggetServicePlugin);

  server.get(
    "/member/nuggets",
    {
      preHandler: verifySession(),
      schema: {
        description: "Returns nuggets belonging to the members' account",
        tags: ["member"],
        response: {
          200: {
            description: "Success Response",
            type: "object",
            properties: {
              nuggets: { type: "array" },
            },
          },
        },
      },
    },
    async (request, reply) => {
      if (request.query.t) {
        let userId = request.session.getUserId();

        const nuggets = await server.nuggetService.getMemberNuggets(
          userId,
          request.query.t
        );

        return {
          nuggets: nuggets,
        };
      } else {
        reply.code(400);
      }
    }
  );

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

  server.get(
    "/member/apps",
    {
      schema: {
        description: "Return list of apps the member has access to",
        tags: ["member"],
        response: {
          200: {
            description: "Success Response",
            type: "object",
            properties: {
              apps: { type: "object" },
            },
          },
        },
      },
    },
    async (request, reply) => {
      return {
        apps: {},
      };
    }
  );
  server.get(
    "/member/app/perms/:appId",
    {
      schema: {
        description: "Return permissioms for a given app.",
        tags: ["member"],
        response: {
          200: {
            description: "Success Response",
            type: "object",
            properties: {
              appId: { type: "string" },
              perms: { type: "object" },
            },
          },
        },
      },
    },
    async (request, reply) => {
      const appId = request.params.appId;
      console.log(request.params);
      return {
        appId: appId,
      };
    }
  );
}

export default fastifyPlugin(memberRoutes);
