const fp = require('fastify-plugin');

const RedisHealthService = (redis) => {

    console.log('RedisHealthService')

    const ping = async () => {

        const resp = await redis.ping();
     
        return { response: resp }
    }

    return { ping }
}

module.exports = fp((fastify, options, next) => {

    fastify.decorate('redisHealthService', RedisHealthService(fastify.redis))
    next()
})