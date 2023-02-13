import fastifyPlugin from "fastify-plugin";
import redisHealthServicePlugin from "../services/redisHealthService.js";

async function healthRoutes(server, options) {
  server.register(redisHealthServicePlugin);

  server.get(
    "/health",
    {
      schema: {
        description: "This is an endpoint for application health check",
        tags: ["health"],
        response: {
          200: {
            description: "Success Response",
            type: "object",
            properties: {
              status: { type: "string" },
            },
          },
        },
      },
    },
    async (request, reply) => {
      return {
        status: "healthy",
      };
    }
  );
  server.get(
    "/health/postgres",
    {
      schema: {
        description:
          "This is an endpoint for application Postgres database health check",
        tags: ["health"],
        response: {
          200: {
            description: "Success Response",
            type: "object",
            properties: {
              status: { type: "string" },
            },
          },
        },
      },
    },
    async (request, reply) => {
      return {
        status: "healthy",
      };
    }
  );
  server.get(
    "/health/redis",
    {
      schema: {
        description:
          "This is an endpoint for application Redis cache health check",
        tags: ["health"],
        response: {
          200: {
            description: "Success Response",
            type: "object",
            properties: {
              status: { type: "string" },
            },
          },
        },
      },
    },
    async (request, reply) => {
        let status = "FAIL";

        const check = await server.redisHealthService.ping();
  
        if (check.response == "PONG") {
          status = "OK";
        }
  
        return { status };
    }
  );
}

export default fastifyPlugin(healthRoutes);
