import { type RouteHandler } from 'fastify'
import type { Params, Querystring, Body, Reply, MemberNotFound } from './schema'
import { members } from './members'

export const getMembersHandler: RouteHandler<{
  Querystring: Querystring
  Reply: Reply
}> = async function (req, reply) {
  const { deleted } = req.query
  if (deleted !== undefined) {
    const filteredMembers = members.filter((member) => member.deleted === deleted)
    reply.send({ members: filteredMembers })
  } else reply.send({ members })
}

export const getOneMemberHandler: RouteHandler<{
  Params: Params
  Reply: Reply | MemberNotFound
}> = async function (req, reply) {
  const { memberUid } = req.params
  const member = members.find((a) => a.uid == memberUid)
  if (member) reply.send({ members: [member] })
  else reply.code(404).send({ error: 'Member not found' })
}

export const postMembersHandler: RouteHandler<{
  Body: Body
  Reply: Body
}> = async function (req, reply) {
  const newMemberID = members.length + 1
  const newMember = {
    id: newMemberID,
    ...req.body
  }
  members.push(newMember)

  reply.code(201).header('Location', `/members/${newMemberID}`).send(newMember)
}

export const putMembersHandler: RouteHandler<{
  Params: Params
  Body: Body
  Reply: MemberNotFound
}> = async function (req, reply) {
  const { memberUid } = req.params
  const member = members.find((p) => p.id == memberUid)
  if (member) {
    member.title = req.body.title
    member.content = req.body.content
    member.tags = req.body.tags
    reply.code(204)
  } else {
    reply.code(404).send({ error: 'Member not found' })
  }
}

export const deleteMembersHandler: RouteHandler<{
  Params: Params
  Reply: MemberNotFound
}> = async function (req, reply) {
  const { memberUid } = req.params
  const member = members.find((p) => p.id == memberUid)
  if (member) {
    member.deleted = true
    reply.code(204)
  } else {
    reply.code(404).send({ error: 'Member not found' })
  }
}
