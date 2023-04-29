import { type RouteHandler } from 'fastify'
import type { Params, Querystring, Body, Reply, InvitationNotFound } from './schema'
import { invitations } from './invitations'

export const getInvitationsHandler: RouteHandler<{
  Querystring: Querystring
  Reply: Reply
}> = async function (req, reply) {
  const { deleted } = req.query
  if (deleted !== undefined) {
    const filteredInvitations = invitations.filter((invitation) => invitation.deleted === deleted)
    reply.send({ invitations: filteredInvitations })
  } else reply.send({ invitations })
}

export const getOneInvitationHandler: RouteHandler<{
  Params: Params
  Reply: Reply | InvitationNotFound
}> = async function (req, reply) {
  const { invitationUid } = req.params
  const invitation = invitations.find((a) => a.uid == invitationUid)
  if (invitation) reply.send({ invitations: [invitation] })
  else reply.code(404).send({ error: 'Invitation not found' })
}

export const postInvitationsHandler: RouteHandler<{
  Body: Body
  Reply: Body
}> = async function (req, reply) {
  const newInvitationID = invitations.length + 1
  const newInvitation = {
    id: newInvitationID,
    ...req.body
  }
  invitations.push(newInvitation)

  reply.code(201).header('Location', `/invitations/${newInvitationID}`).send(newInvitation)
}

export const putInvitationsHandler: RouteHandler<{
  Params: Params
  Body: Body
  Reply: InvitationNotFound
}> = async function (req, reply) {
  const { invitationUid } = req.params
  const invitation = invitations.find((p) => p.id == invitationUid)
  if (invitation) {
    invitation.title = req.body.title
    invitation.content = req.body.content
    invitation.tags = req.body.tags
    reply.code(204)
  } else {
    reply.code(404).send({ error: 'Invitation not found' })
  }
}

export const deleteInvitationsHandler: RouteHandler<{
  Params: Params
  Reply: InvitationNotFound
}> = async function (req, reply) {
  const { invitationUid } = req.params
  const invitation = invitations.find((p) => p.id == invitationUid)
  if (invitation) {
    invitation.deleted = true
    reply.code(204)
  } else {
    reply.code(404).send({ error: 'Invitation not found' })
  }
}
