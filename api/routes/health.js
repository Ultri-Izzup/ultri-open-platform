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
      let status = "FAIL";

      const dbCheck = await server.postgresHealthService.getNow();

      const currentTime = new Date().getTime();
      const dbCurrentTime = new Date(dbCheck.current_timestamp).getTime();

      const drift = Math.abs(currentTime - dbCurrentTime);

      if (drift < 1000) {
        status = "OK";
      } else {
        status = "DRIFT-DETECTED";
      }

      return { status };
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
