import type { FastifyInstance } from 'fastify'
import {
  getStatusSchema,
} from './schema'
import {
  getBaseHandler,
  getPostgresHandler,
  getRedisHandler
} from './handler'

export default async (fastify: FastifyInstance) => {
  // fastify.addSchema(statusSchema)
  fastify.get('/', { schema: getStatusSchema }, getBaseHandler)
  fastify.get('/postgres', { schema: getStatusSchema }, getPostgresHandler)
  fastify.post('/redis', { schema: getStatusSchema }, getRedisHandler)
}
