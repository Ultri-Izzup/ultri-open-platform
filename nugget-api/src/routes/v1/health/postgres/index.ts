import type { FastifyPluginAsync } from 'fastify'

const postgres: FastifyPluginAsync = async (fastify): Promise<void> => {
  // Note: using an arrow function will break the binding of this to the FastifyInstance.
  fastify.get('/', async function (req, reply) {
    return {
        status: "up",
      };
  })
}

export default postgres