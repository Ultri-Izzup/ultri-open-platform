import type { FastifyInstance } from 'fastify'
import {
  accountSchema,
  accountNotFoundSchema,
  getAccountsSchema,
  getOneAccountSchema,
  postAccountsSchema,
  putAccountsSchema,
  deleteAccountsSchema,
  postAccountRoleSchema,
  putAccountRoleSchema,
  deleteAccountRoleSchema,
  postAccountGroupSchema,
  putAccountGroupSchema,
  deleteAccountGroupSchema
} from './schema'
import {
  getAccountsHandler,
  getOneAccountHandler,
  postAccountsHandler,
  putAccountsHandler,
  deleteAccountsHandler,
  postAccountRoleHandler,
  putAccountRoleHandler,
  deleteAccountRoleHandler,
  postAccountGroupHandler,
  putAccountGroupHandler,
  deleteAccountGroupHandler
} from './handler'

export default async (fastify: FastifyInstance) => {
  fastify.addSchema(accountSchema)
  fastify.addSchema(accountNotFoundSchema)
  fastify.get('/', { schema: getAccountsSchema }, getAccountsHandler)
  fastify.get('/:accountUid', { schema: getOneAccountSchema }, getOneAccountHandler)
  fastify.post('/', { schema: postAccountsSchema }, postAccountsHandler)
  fastify.put('/:accountUid', { schema: putAccountsSchema }, putAccountsHandler)
  fastify.delete('/:accountUid', { schema: deleteAccountsSchema }, deleteAccountsHandler)
  fastify.post('/:accountUid/roles', { schema: postAccountRoleSchema }, postAccountRoleHandler)
  fastify.put('/:accountUid/roles/:roleName', { schema: putAccountRoleSchema }, putAccountRoleHandler)
  fastify.delete('/:accountUid/roles/:roleName', { schema: deleteAccountRoleSchema }, deleteAccountRoleHandler),
  fastify.post('/:accountUid/groups', { schema: postAccountGroupSchema }, postAccountGroupHandler)
  fastify.put('/:accountUid/groups/:groupName', { schema: putAccountGroupSchema }, putAccountGroupHandler)
  fastify.delete('/:accountUid/groups/:groupName', { schema: deleteAccountGroupSchema }, deleteAccountGroupHandler)
}
