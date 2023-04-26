import type { FastifyInstance } from 'fastify'
import {
  commentSchema,
  commentNotFoundSchema,
  getCommentsSchema,
  getOneCommentSchema,
  postCommentsSchema,
  putCommentsSchema,
  deleteCommentsSchema
} from './schema'
import {
  getCommentsHandler,
  getOneCommentHandler,
  postCommentsHandler,
  putCommentsHandler,
  deleteCommentsHandler
} from './handler'

export default async (fastify: FastifyInstance) => {
  fastify.addSchema(commentSchema)
  fastify.addSchema(commentNotFoundSchema)
  // List of top-level comments for a nugget
  fastify.get('/nugget/:nuggetUid', { schema: getCommentsSchema }, getCommentsHandler)
  // Create a new comment 
  fastify.post('/nugget/:nuggetUid/account/:accountUid', { schema: postCommentsSchema }, postCommentsHandler)
  // Get a single comment
  fastify.get('/:commentUid', { schema: getOneCommentSchema }, getOneCommentHandler)
  // Update a comment, only accessible to the creator 
  fastify.put('/:commentUid', { schema: putCommentsSchema }, putCommentsHandler)
  // Delete a comment, only accessible to the creator 
  fastify.delete('/:commentUid', { schema: deleteCommentsSchema }, deleteCommentsHandler)
}
