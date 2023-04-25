import type { FastifyInstance } from 'fastify'
import {
  nuggetSchema,
  nuggetNotFoundSchema,
  getNuggetsSchema,
  getOneNuggetSchema,
  postNuggetsSchema,
  putNuggetsSchema,
  putNuggetPublishSchema,
  deleteNuggetsSchema
} from './schema'
import {
  getNuggetsHandler,
  getOneNuggetHandler,
  postNuggetsHandler,
  putNuggetsHandler,
  patchNuggetsHandler,
  putNuggetPublishHandler,
  deleteNuggetsHandler
} from './handler'

export default async (fastify: FastifyInstance) => {
  fastify.addSchema(nuggetSchema)
  fastify.addSchema(nuggetNotFoundSchema)
  fastify.get('/', { schema: getNuggetsSchema }, getNuggetsHandler)
  fastify.get('/:nuggetUid', { schema: getOneNuggetSchema }, getOneNuggetHandler)
  fastify.post('/', { schema: postNuggetsSchema }, postNuggetsHandler)
  fastify.put('/:nuggetUid', { schema: putNuggetsSchema }, putNuggetsHandler)
  fastify.patch('/:nuggetUid', { schema: putNuggetsSchema }, patchNuggetsHandler)
  fastify.put('/:nuggetUid/publish', { schema: putNuggetPublishSchema }, putNuggetPublishHandler)
  fastify.delete('/:nuggetUid', { schema: deleteNuggetsSchema }, deleteNuggetsHandler)
}
