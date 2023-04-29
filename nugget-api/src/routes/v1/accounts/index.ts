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
  deleteAccountGroupSchema,
  putAccountMemberSchema,
  deleteAccountMemberSchema,
  postAccountGroupMemberSchema,
  deleteAccountGroupMemberSchema
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
  deleteAccountGroupHandler,
  putAccountMemberHandler,
  deleteAccountMemberHandler,
  postAccountGroupMemberHandler,
  deleteAccountGroupMemberHandler
} from './handler'

// All routes limit access to the records the authed member has acccess to

export default async (fastify: FastifyInstance) => {
  fastify.addSchema(accountSchema)
  fastify.addSchema(accountNotFoundSchema)
  // List authed member accounts
  fastify.get('/', { schema: getAccountsSchema }, getAccountsHandler)
  // Account Records
  fastify.get('/:accountUid', { schema: getOneAccountSchema }, getOneAccountHandler)
  fastify.post('/', { schema: postAccountsSchema }, postAccountsHandler)
  fastify.put('/:accountUid', { schema: putAccountsSchema }, putAccountsHandler)
  fastify.delete('/:accountUid', { schema: deleteAccountsSchema }, deleteAccountsHandler)
  // Account Roles
  fastify.post('/:accountUid/roles', { schema: postAccountRoleSchema }, postAccountRoleHandler)
  fastify.put('/:accountUid/roles/:roleUid', { schema: putAccountRoleSchema }, putAccountRoleHandler)
  fastify.delete('/:accountUid/roles/:roleUid', { schema: deleteAccountRoleSchema }, deleteAccountRoleHandler)
  // Account Groups
  fastify.post('/:accountUid/groups', { schema: postAccountGroupSchema }, postAccountGroupHandler)
  fastify.put('/:accountUid/groups/:groupUid', { schema: putAccountGroupSchema }, putAccountGroupHandler)
  fastify.delete('/:accountUid/groups/:groupUid', { schema: deleteAccountGroupSchema }, deleteAccountGroupHandler)
  // Account Members
  fastify.put('/:accountUid/members/:memberUid', { schema: putAccountMemberSchema }, putAccountMemberHandler)
  fastify.delete('/:accountUid/members/:memberUid', { schema: deleteAccountMemberSchema }, deleteAccountMemberHandler)
  // Account Group Members
  fastify.post('/:accountUid/groups/:groupUid/members', { schema: postAccountGroupMemberSchema }, postAccountGroupMemberHandler)
  fastify.delete('/:accountUid/groups/:groupUid/members/:memberUid', { schema: deleteAccountGroupMemberSchema }, deleteAccountGroupMemberHandler)
}
