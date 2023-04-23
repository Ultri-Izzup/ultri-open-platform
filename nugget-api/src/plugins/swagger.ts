import fp from 'fastify-plugin'
import swagger from '@fastify/swagger'
import swaggerUi from '@fastify/swagger-ui'

export default fp(async (fastify) => {
  fastify.register(swagger, {
    openapi: {
      info: {
        title: 'Nugget Server',
        description: 'Use Nuggets to store and relate your data.',
        version: '0.1.0'
      },
      servers: [
        {
          url: 'http://127.0.0.1:3005'
        }
      ]
    },
    hideUntagged: true
  })
  fastify.register(swaggerUi)
})