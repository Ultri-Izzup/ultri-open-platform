import { join } from 'path'
import fastify from 'fastify'
import autoLoad from '@fastify/autoload'

const server = fastify()

server.register(autoLoad, {
    dir: join(__dirname, 'plugins')
})

server.register(autoLoad, {
    dir: join(__dirname, 'routes')
})

server.get('/ping', async (request, reply) => {
    return 'pong\n'
})

server.listen({ port: 3005, host: '0.0.0.0' }, (err, address) => {
    if (err) {
        console.error(err)
        process.exit(1)
    }
    console.log(`Server listening at ${address}`)
})