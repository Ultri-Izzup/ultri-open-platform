const fp = require("fastify-plugin");

module.exports = fp(async function(fastify, opts, done) {
  await fastify.register(require("@fastify/swagger"));

  await fastify.register(require('@fastify/swagger-ui'), {
    routePrefix: '/documentation',
    swagger: {
        info: {
          title: 'Ultri Open Platform API',
          description: 'Open Platform API used for Izzup.com',
          version: '0.1.0'
        },
        host: 'localhost:3000',
        schemes: ['http'],
        consumes: ['application/json'],
        produces: ['application/json'],
      },

    uiConfig: {
      docExpansion: 'full',
      deepLinking: false 
    },
    uiHooks: {
      onRequest: function (request, reply, next) { next() },
      preHandler: function (request, reply, next) { next() }
    },
    staticCSP: true,
    transformStaticCSP: (header) => header,
    transformSpecification: (swaggerObject, request, reply) => { return swaggerObject },
    transformSpecificationClone: true
  })
})
