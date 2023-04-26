import { type RouteHandler } from 'fastify'
import type { Params, Querystring, Body, Reply, ReactionNotFound } from './schema'
import { reactions } from './reactions'

export const getReactionsHandler: RouteHandler<{
  Querystring: Querystring
  Reply: Reply
}> = async function (req, reply) {
  const { deleted } = req.query
  if (deleted !== undefined) {
    const filteredReactions = reactions.filter((reaction) => reaction.deleted === deleted)
    reply.send({ reactions: filteredReactions })
  } else reply.send({ reactions })
}

export const getOneReactionHandler: RouteHandler<{
  Params: Params
  Reply: Reply | ReactionNotFound
}> = async function (req, reply) {
  const { reactionUid } = req.params
  const reaction = reactions.find((a) => a.uid == reactionUid)
  if (reaction) reply.send({ reactions: [reaction] })
  else reply.code(404).send({ error: 'Reaction not found' })
}

export const postReactionsHandler: RouteHandler<{
  Body: Body
  Reply: Body
}> = async function (req, reply) {
  const newReactionID = reactions.length + 1
  const newReaction = {
    id: newReactionID,
    ...req.body
  }
  reactions.push(newReaction)

  reply.code(201).header('Location', `/reactions/${newReactionID}`).send(newReaction)
}

export const putReactionsHandler: RouteHandler<{
  Params: Params
  Body: Body
  Reply: ReactionNotFound
}> = async function (req, reply) {
  const { reactionUid } = req.params
  const reaction = reactions.find((p) => p.id == reactionUid)
  if (reaction) {
    reaction.title = req.body.title
    reaction.content = req.body.content
    reaction.tags = req.body.tags
    reply.code(204)
  } else {
    reply.code(404).send({ error: 'Reaction not found' })
  }
}

export const deleteReactionsHandler: RouteHandler<{
  Params: Params
  Reply: ReactionNotFound
}> = async function (req, reply) {
  const { reactionUid } = req.params
  const reaction = reactions.find((p) => p.id == reactionUid)
  if (reaction) {
    reaction.deleted = true
    reply.code(204)
  } else {
    reply.code(404).send({ error: 'Reaction not found' })
  }
}
