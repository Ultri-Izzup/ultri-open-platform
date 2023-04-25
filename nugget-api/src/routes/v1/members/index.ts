import type { FastifyInstance } from 'fastify'
import {
  memberSchema,
  memberNotFoundSchema,
  getMembersSchema,
  getOneMemberSchema,
  postMembersSchema,
  putMembersSchema,
  deleteMembersSchema
} from './schema'
import {
  getMembersHandler,
  getOneMemberHandler,
  postMembersHandler,
  putMembersHandler,
  deleteMembersHandler
} from './handler'

export default async (fastify: FastifyInstance) => {
  fastify.addSchema(memberSchema)
  fastify.addSchema(memberNotFoundSchema)
  fastify.get('/', { schema: getMembersSchema }, getMembersHandler)
  fastify.get('/:memberUid', { schema: getOneMemberSchema }, getOneMemberHandler)
  fastify.post('/', { schema: postMembersSchema }, postMembersHandler)
  fastify.put('/:memberUid', { schema: putMembersSchema }, putMembersHandler)
  fastify.delete('/:memberUid', { schema: deleteMembersSchema }, deleteMembersHandler)
}
