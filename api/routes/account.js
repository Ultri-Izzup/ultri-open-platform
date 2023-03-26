import fastifyPlugin from "fastify-plugin";
import accountServicePlugin from "../services/accountService.js";

import Passwordless from "supertokens-node/recipe/passwordless/index.js";
import { verifySession } from "supertokens-node/recipe/session/framework/fastify/index.js";
import st from "supertokens-node/framework/fastify/index.js";
const { SessionRequest } = st;

async function accountRoutes(server, options) {
  server.register(accountServicePlugin);

  server.get(
    "/account",
    {
      preHandler: verifySession(),
      schema: {
        description: "Return account info",
        tags: ["account"],
        response: {
          200: {
            description: "Success Response",
            type: "object",
            properties: {
              name: { type: "string" },
            },
          },
        },
      },
    },
    async (request, reply) => {
      return {
        name: "Brian Winkers",
      };
    }
  );

  server.post(
    "/account",
    {
      preHandler: verifySession(),
      schema: {
        description: "Create a new account",
        tags: ["account"],
        summary: "Add a new account to the database",
        body: {
          type: "object",
          properties: {
            name: {
              type: "string",
              description: "The name for the account",
            },
          },
        },
        response: {
          200: {
            description: "Success Response",
            type: "object",
            properties: {
              uid: { type: "string" },
              name: { type: "string" },
              createdAt: { type: "string" }
            },
          },
        },
      },
    },
    async (req, reply) => {
      let userId = req.session.getUserId();
      console.log("USERID", userId);

      const result = await server.accountService.createAccount(req.body, userId);
      console.log("CREATE", result);

      return result;
    }
  );

  server.get(
    "/account/accounts",
    {
      preHandler: verifySession(),
      schema: {
        description: "Returns accounts belonging to the accounts' account",
        tags: ["account"],
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
      if (request.query.t) {
        let userId = request.session.getUserId();

        const accounts = await server.accountService.getAccountAccounts(userId, request.query.t);
        

        return {
          accounts: accounts,
        };
      } else {
        reply.code(400)
      }
    }
  );

  server.get(
    "/account/apps",
    {
      schema: {
        description: "Return list of apps the account has access to",
        tags: ["account"],
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
    "/account/app/perms/:appId",
    {
      schema: {
        description: "Return permissioms for a given app.",
        tags: ["account"],
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

export default fastifyPlugin(accountRoutes);
