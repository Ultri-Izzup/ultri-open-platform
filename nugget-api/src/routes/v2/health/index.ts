import type { FastifyPluginAsync } from 'fastify'

const health: FastifyPluginAsync = async (fastify): Promise<void> => {
  // Note: using an arrow function will break the binding of this to the FastifyInstance.
  fastify.get('/', {
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
  async function (req, reply) {
    return {
        status: "up",
      };
  })
}

export default health