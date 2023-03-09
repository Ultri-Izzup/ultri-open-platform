import fastifyPlugin from "fastify-plugin";
import memberServicePlugin from "../services/memberService.js";

import Passwordless from "supertokens-node/recipe/passwordless/index.js";
import { verifySession } from "supertokens-node/recipe/session/framework/fastify/index.js";
import st from "supertokens-node/framework/fastify/index.js";
const { SessionRequest } = st;

async function memberRoutes(server, options) {
  server.register(memberServicePlugin);

  server.get(
    "/member",
    {
      preHandler: verifySession(),
      schema: {
        description: "Return member info",
        tags: ["member"],
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
    "/member/register",
    {
      preHandler: verifySession(),
      schema: {
        description: "Register a new or returning member",
        tags: ["member"],
        summary: "This updates an existing members last_signin time.",
        body: {
          type: "object",
          properties: {
            ping: {
              type: "string",
              description: "A 4 character string",
            }
          }
        },
        response: {
          200: {
            description: "Success Response",
            type: "object",
            properties: {
              email: { type: "string" },
              uid: { type: "string" },
              isNewMember: { type: "boolean" },
            },
          },
        },
      },
    },
    async (req, reply) => {

      let userId = req.session.getUserId();
      console.log('USERID', userId)
      // You can learn more about the `User` object over here https://github.com/supertokens/core-driver-interface/wiki
      let userInfo = await Passwordless.getUserById({ userId: userId});
       console.log('USER INFO',userInfo)


      const regResult = await server.memberService.registerMember(userInfo);
      console.log("REGISTER", regResult);

      return regResult;
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
