import { join } from 'path'
import Fastify from 'fastify'
import autoLoad from '@fastify/autoload'

const fastify = Fastify({
  logger: {
    transport: {
      target: 'pino-pretty',
      options: {
        destination: 1,
        colorize: true,
        translateTime: 'HH:MM:ss.l',
        ignore: 'pid,hostname'
      }
    }
  }
})
// Register Configs first so anything else can access
fastify.register(autoLoad, {
  dir: join(__dirname, 'config')
})
// Register the raw building blocks of the fastify app.
fastify.register(autoLoad, {
  dir: join(__dirname, 'plugins')
})
// Route requests to services, using defined schemas for request and response
fastify.register(autoLoad, {
  dir: join(__dirname, 'routes')
})


// Start server
const start = async () => {
  try {
    await fastify.listen({ port: 3005, host: '0.0.0.0' })
  } catch (err) {
    fastify.log.error(err)
    process.exit(1)
  }
}

start()
