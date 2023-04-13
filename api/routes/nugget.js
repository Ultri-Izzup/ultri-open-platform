import fastifyPlugin from "fastify-plugin";
import nuggetServicePlugin from "../services/nuggetService.js";

import { verifySession } from "supertokens-node/recipe/session/framework/fastify/index.js";

async function nuggetRoutes(server, options) {
  server.register(nuggetServicePlugin);

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
          required: ["nuggetType"],
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
            accountUid: {
              type: "string",
              description: "The account to use when creating the nugget",
            },
            blocks: {
              type: "array",
              description: "The sequenced block data for the nugget",
              items: {
                type: "object",
                required: ["id", "type"],
                properties: {
                  id: {
                    type: "string",
                  },
                  type: {
                    type: "string",
                  },
                  jsonData: {
                    type: "object",
                  },
                },
              },
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
              createdAt: { type: "string" },
              accountUid: { type: "string" },
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

  // GET member nuggets
  server.get(
    "/nuggets/member",
    {
      preHandler: verifySession(),
      schema: {
        description: "Returns nuggets belonging to the members' account",
        tags: ["nugget", "member"],
        response: {
          200: {
            description: "Success Response",
            type: "object",
            properties: {
              nuggets: {
                type: "array",
                items: {
                  type: "object",
                  properties: {
                    nuggetUid: {
                      type: "string",
                      description: "The nugget unique ID.",
                    },
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
                    accountUid: {
                      type: "string",
                      description: "The unique account ID for the nugget owner",
                    },
                    createdAt: {
                      type: "string",
                      description: "The creation date and time",
                    },
                    publishedAt: {
                      type: "string",
                      description: "The time and date to publish",
                    },
                    unPublishAt: {
                      type: "string",
                      description: "The time and date to un-publish",
                    },
                  },
                },
              },
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

  // GET account nuggets
  server.get(
    "/nuggets/account/:accountUid",
    {
      preHandler: verifySession(),
      schema: {
        description: "Returns nuggets belonging to the account",
        tags: ["nugget", "account"],
        params: {
          type: "object",
          properties: {
            accountUid: {
              type: "string",
              description: "Account unique id",
            },
          },
        },
        response: {
          200: {
            description: "Success Response",
            type: "object",
            properties: {
              nuggets: {
                type: "array",
                items: {
                  type: "object",
                  properties: {
                    uid: {
                      type: "string",
                      description: "The nugget unique ID.",
                    },
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
                    accountUid: {
                      type: "string",
                      description: "The unique account ID for the nugget owner",
                    },
                    createdAt: {
                      type: "string",
                      description: "The creation date and time",
                    },
                    publishedAt: {
                      type: "string",
                      description: "The time and date to publish",
                    },
                    unPublishAt: {
                      type: "string",
                      description: "The time and date to un-publish",
                    },
                  },
                },
              },
            },
          },
        },
      },
    },
    async (request, reply) => {
      if (request.query.t) {
        let userId = request.session.getUserId();

        const nuggets = await server.nuggetService.getAccountNuggets(
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

  // GET a specific nugget
  server.get(
    "/nugget/:nuggetUid",
    {
      preHandler: verifySession(),
      schema: {
        description: "Returns a specific nugget",
        tags: ["member"],
        params: {
          type: "object",
          properties: {
            nuggetUid: {
              type: "string",
              description: "Nugget unique id",
            },
          },
        },
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

        const nuggets = await server.nuggetService.getNugget(nuggetUid, userId);

        return {
          nuggets: nuggets,
        };
      } else {
        reply.code(400);
      }
    }
  );

  // UPDATE a Nugget
  server.post(
    "/nugget/:nuggetUid",
    {
      preHandler: verifySession(),
      schema: {
        description: "Create a new nugget",
        tags: ["nugget"],
        summary: "Add a new nugget of info to the database",
        params: {
          type: "object",
          properties: {
            nuggetUid: {
              type: "string",
              description: "Nugget unique id",
            },
          },
        },
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
            accountUid: {
              type: "string",
              description: "The account to use when creating the nugget",
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
              createdAt: { type: "string" },
              accountUid: { type: "string" },
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

  // SET Nugget blocks
  server.post(
    "/nugget/:nuggetUid/blocks",
    {
      preHandler: verifySession(),
      schema: {
        description: "Create a new nugget",
        tags: ["nugget"],
        summary: "Add a new nugget of info to the database",
        params: {
          type: "object",
          properties: {
            nuggetUid: {
              type: "string",
              description: "Nugget unique id",
            },
          },
        },
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
            accountUid: {
              type: "number",
              description: "The account to use when creating the nugget",
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
              createdAt: { type: "string" },
              accountUid: { type: "string" },
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

  // DELETE a Nugget
  server.delete(
    "/nugget/:nuggetUid",
    {
      preHandler: verifySession(),
      schema: {
        description: "Create a new nugget",
        tags: ["nugget"],
        summary: "Add a new nugget of info to the database",
        params: {
          type: "object",
          properties: {
            nuggetUid: {
              type: "string",
              description: "Nugget unique id",
            },
          },
        },
        response: {
          204: {
            description: "Success Response",
            type: "null",
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

  // DELETE a Nugget Block
  server.delete(
    "/nugget/:nuggetUid/block/:blockUid",
    {
      preHandler: verifySession(),
      schema: {
        description: "Create a new nugget",
        tags: ["nugget"],
        summary: "Add a new nugget of info to the database",
        params: {
          type: "object",
          properties: {
            nuggetUid: {
              type: "string",
              description: "Nugget unique id",
            },
            blockUid: {
              type: "string",
              description: "Block unique id",
            },
          },
        },
        response: {
          204: {
            description: "Success Response",
            type: "null",
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

  // PUBLISH / UN-PUBLISH a Nugget
  server.post(
    "/nugget/:nuggetUid/publish",
    {
      preHandler: verifySession(),
      schema: {
        description: "Create a new nugget",
        tags: ["nugget"],
        summary: "ChangSe publishing info for a nugget",
        params: {
          type: "object",
          properties: {
            nuggetUid: {
              type: "string",
              description: "Nugget unique id",
            },
          },
        },
        body: {
          type: "object",
          properties: {
            pubAt: {
              type: "string",
              description: "The title to use for public display",
            },
            unPubAt: {
              type: "string",
              description: "The name to use for internal management",
            },
          },
        },
        response: {
          202: {
            description: "Success Response",
            type: "null",
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

// fetchNuggets(nuggetType, accountUid=null) {
// fetchNugget(nuggetUid) {
// createNugget(nuggetData, accountUid=null) {
// updateNugget(nuggetUid, nuggetData) {
// mergeNuggetBlock(nuggetUid, blocksData) {
// deleteNugget(nuggetUid) {
// deleteNuggetBlocks(nuggetUid, blockUids) {
// publishNugget(nuggetUid, pubAt=null, unPubAt=null) {
// unPublishNugget(nuggetUid) {
