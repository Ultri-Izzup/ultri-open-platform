import fp from 'fastify-plugin'
import swagger from '@fastify/swagger'
import swaggerUi from '@fastify/swagger-ui'

export default fp(async (fastify) => {
  fastify.register(swagger, {
    openapi: {
      info: {
        title: 'Ultri Nugget Server',
        description: 'Store and relate your publishing data as nuggets',
        version: '0.1.0'
      },
      servers: [
        {
          url: 'http://localhost'
        }
      ]
    },
    hideUntagged: true
  })
  fastify.register(swaggerUi)
})
