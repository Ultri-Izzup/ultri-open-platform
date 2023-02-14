"use strict";
const postgresHealthServicePlugin = require("../../services/postgresHealthService");
const redisHealthServicePlugin = require("../../services/redisHealthService");

module.exports = async function(fastify, opts) {
  fastify.register(postgresHealthServicePlugin);
  fastify.register(redisHealthServicePlugin);

  fastify.get(
    "/",
    {
      schema: {
        description: "This is an endpoint for application health check",
        tags: ["health"],
        response: {
          200: {
            description: "Success Response",
            type: "object",
            properties: {
              msg: { type: "string" },
            },
          },
        },
      },
    },
    (request, reply) => {
      reply.send({ msg: "The API is reachable." });
    }
  );

  fastify.get(
    "/postgres",
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

      const dbCheck = await fastify.postgresHealthService.getNow();

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

  fastify.get(
    "/redis",
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

      const check = await fastify.redisHealthService.ping();

      if (check.response == "PONG") {
        status = "OK";
      }

      return { status };
    }
  );
};
