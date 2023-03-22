import fastifyPlugin from "fastify-plugin";
import nuggetServicePlugin from "../services/nuggetService.js";

import { verifySession } from "supertokens-node/recipe/session/framework/fastify/index.js";

async function nuggetRoutes(server, options) {
  // server.register(nuggetServicePlugin);

  // CREATE a Nugget
  server.post(
    "/nugget",
    {
      preHandler: verifySession(),
      schema: {
        description: "Create a new nugget",
        tags: ["nugget"],
        summary: "Add a new nugget of info to the database",
        body: {
          type: "object",
          properties: {
            publicTitle: {
              type: "string",
              description: "The title to use for public display",
            },
            internalName: {
              type: "string",
              description: "The name to use for internal management",
            },
            nuggetType: {
                type: "string",
                description: "The type of nugget to create",
              },
          },
        },
        response: {
          200: {
            description: "Success Response",
            type: "object",
            properties: {
              uid: { type: "string" },
              publicTitle: { type: "string" },
              internalName: { type: "string" },
              nugget_type: { type: "string" },
              createdAt: { type: "string" }
            },
          },
        },
      },
    },
    async (req, reply) => {
      let userId = req.session.getUserId();
      console.log("USERID", userId);

      const result = await server.nuggetService.createNugget(req.body, userId);
      console.log("CREATE", result);

      return result;
    }
  );
}

export default fastifyPlugin(nuggetRoutes);
