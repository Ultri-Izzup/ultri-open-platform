import fastifyPlugin from "fastify-plugin";
import memberServicePlugin from "../services/memberService.js";

import { verifySession } from "supertokens-node/recipe/session/framework/fastify/index.js";
import st from "supertokens-node/framework/fastify/index.js";
const { SessionRequest } = st;

async function memberRoutes(server, options) {
  server.register(memberServicePlugin);

  server.get(
    "/member",
    {
      schema: {
        description: "Return member info",
        tags: ["member"],
        response: {
          200: {
            description: "Success Response",
            type: "object",
            properties: {
               name : { type: "string" },

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
               apps : { type: "object" },
            },
          },
        },
      },
    },
    async (request, reply) => {
      return {
        apps: {},
      }
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
               appId : { type: "string" },
               perms : { type: "object" },
            },
          },
        },
      },
    },
    async (request, reply) => {
        const appId = request.params.appId
        console.log(request.params)
      return {

 
            appId: appId
    
      }
    }
  );

}

export default fastifyPlugin(memberRoutes);