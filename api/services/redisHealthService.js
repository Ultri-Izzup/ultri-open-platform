import fp from 'fastify-plugin';

const RedisHealthService = (redis) => {

    console.log('RedisHealthService loaded')

    const ping = async () => {

        const resp = await redis.ping();
     
        return { response: resp }
    }

    return { ping }
}

export default fp((server, options, next) => {

    server.decorate('redisHealthService', RedisHealthService(server.redis))
    next()
})