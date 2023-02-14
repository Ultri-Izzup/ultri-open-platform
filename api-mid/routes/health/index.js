"use strict";
//const postgresHealthServicePlugin = require("../../services/postgresHealthService");
//const redisHealthServicePlugin = require("../../services/redisHealthService");

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


};
