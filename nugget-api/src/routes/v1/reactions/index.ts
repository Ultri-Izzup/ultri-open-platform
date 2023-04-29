import type { FastifyInstance } from 'fastify'
import {
  reactionSchema,
  reactionNotFoundSchema,
  getReactionsSchema,
  getOneReactionSchema,
  postReactionsSchema,
  putReactionsSchema,
  deleteReactionsSchema
} from './schema'
import {
  getReactionsHandler,
  getOneReactionHandler,
  postReactionsHandler,
  putReactionsHandler,
  deleteReactionsHandler
} from './handler'

export default async (fastify: FastifyInstance) => {
  fastify.addSchema(reactionSchema)
  fastify.addSchema(reactionNotFoundSchema)
  // Summary of reactions for a nugget
  fastify.get('/nugget/:nuggetUid', { schema: getReactionsSchema }, getReactionsHandler)
  // Create a new reaction 
  fastify.post('/nugget/:nuggetUid/account/:accountUid', { schema: postReactionsSchema }, postReactionsHandler)
  // Get a single reaction
  fastify.get('/nugget/:nuggetUid/account/:accountUid', { schema: getOneReactionSchema }, getOneReactionHandler)
  // Update a reaction, only accessible to the account
  fastify.put('/nugget/:nuggetUid/account/:accountUid', { schema: putReactionsSchema }, putReactionsHandler)
  // Delete a reaction, only accessible to the account 
  fastify.delete('/nugget/:nuggetUid/account/:accountUid', { schema: deleteReactionsSchema }, deleteReactionsHandler)
}
