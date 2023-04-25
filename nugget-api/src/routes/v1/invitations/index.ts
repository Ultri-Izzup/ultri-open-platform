import type { FastifyInstance } from 'fastify'
import {
  invitationSchema,
  invitationNotFoundSchema,
  getInvitationsSchema,
  getOneInvitationSchema,
  postInvitationsSchema,
  putInvitationsSchema,
  deleteInvitationsSchema
} from './schema'
import {
  getInvitationsHandler,
  getOneInvitationHandler,
  postInvitationsHandler,
  putInvitationsHandler,
  deleteInvitationsHandler
} from './handler'

export default async (fastify: FastifyInstance) => {
  fastify.addSchema(invitationSchema)
  fastify.addSchema(invitationNotFoundSchema)
  // Get invitations sent by a member
  fastify.get('/', { schema: getInvitationsSchema }, getInvitationsHandler)
  // Get a specific Invitation
  fastify.get('/:invitationUid', { schema: getOneInvitationSchema }, getOneInvitationHandler)
  // Create a member invitation
  fastify.post('/', { schema: postInvitationsSchema }, postInvitationsHandler)
  // Update a member invitation
  fastify.put('/:invitationUid', { schema: putInvitationsSchema }, putInvitationsHandler)

  // Get invitations sent by an account
  fastify.get('/account/:accountUid', { schema: getInvitationsSchema }, getInvitationsHandler)
  // Get a specific account Invitation
  fastify.get('/account/:accountUid/:invitationUid', { schema: getOneInvitationSchema }, getOneInvitationHandler)
  // Create an account invitation
  fastify.post('/account/:accountUid', { schema: postInvitationsSchema }, postInvitationsHandler)
  // Update a member invitation
  fastify.put('/account/:accountUid/:invitationUid', { schema: putInvitationsSchema }, putInvitationsHandler)

  // Respond to an invitation
  fastify.post('/rsvp/:invitationUid', { schema: postInvitationsSchema }, postInvitationsHandler)
}
