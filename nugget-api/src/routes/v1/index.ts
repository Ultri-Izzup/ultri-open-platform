import type { FastifyPluginAsync } from 'fastify'

const v1: FastifyPluginAsync = async (fastify): Promise<void> => {
  // Note: using an arrow function will break the binding of this to the FastifyInstance.
  fastify.get('/', async function (req, reply) {
    return {
        version: "1",
      };
  })
}

export default v1