const fp = require('fastify-plugin');

const PostgresHealthService = (postgres) => {

    console.log('PostgresHealthService')

    const getNow = async () => {
        const nowtime = await postgres.one('SELECT CURRENT_TIMESTAMP')
        console.log(nowtime)
        return nowtime;
    }

    return { getNow }
}

module.exports = fp((fastify, options, next) => {

    fastify.decorate('postgresHealthService', PostgresHealthService(fastify.postgres))
    next()
})