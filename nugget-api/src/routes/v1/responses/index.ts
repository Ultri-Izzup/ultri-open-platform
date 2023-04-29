import type { FastifyInstance } from 'fastify'
import {
  responseSchema,
  responseNotFoundSchema,
  getResponsesSchema,
  getOneResponseSchema,
  postResponsesSchema,
  putResponsesSchema,
  deleteResponsesSchema
} from './schema'
import {
  getResponsesHandler,
  getOneResponseHandler,
  postResponsesHandler,
  putResponsesHandler,
  deleteResponsesHandler
} from './handler'

export default async (fastify: FastifyInstance) => {
  fastify.addSchema(responseSchema)
  fastify.addSchema(responseNotFoundSchema)
  // List of top-level responses for a nugget
  fastify.get('/nugget/:nuggetUid', { schema: getResponsesSchema }, getResponsesHandler)
  // List of responses to a given response
  fastify.get('/response/:responseUid', { schema: getResponsesSchema }, getResponsesHandler)
  // Create a response to a comment
  fastify.post('/comment/:commentUid', { schema: postResponsesSchema }, postResponsesHandler)
  // Get a single response
  fastify.get('/:responseUid', { schema: getOneResponseSchema }, getOneResponseHandler)
  // Update a response, only accessible to the creator 
  fastify.put('/:responseUid', { schema: putResponsesSchema }, putResponsesHandler)
  // Delete a response, only accessible to the creator 
  fastify.delete('/:responseUid', { schema: deleteResponsesSchema }, deleteResponsesHandler)
}
