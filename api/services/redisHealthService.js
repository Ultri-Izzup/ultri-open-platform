import fp from 'fastify-plugin';

const RedisHealthService = (redis) => {

    console.log('RedisHealthService loaded')

    const ping = async () => {

        const resp = await redis.ping();
     
        return { response: resp }
    }

    return { ping }
}

export default fp((fastify, options, next) => {

    fastify.decorate('redisHealthService', RedisHealthService(fastify.redis))
    next()
})