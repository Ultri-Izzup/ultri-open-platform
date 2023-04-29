import { type RouteHandler } from 'fastify'
import type { Params, Querystring, Body, Reply, NuggetNotFound } from './schema'
import { nuggets } from './nuggets'

export const getNuggetsHandler: RouteHandler<{
  Querystring: Querystring
  Reply: Reply
}> = async function (req, reply) {
  const { deleted } = req.query
  if (deleted !== undefined) {
    const filteredNuggets = nuggets.filter((nugget) => nugget.deleted === deleted)
    reply.send({ nuggets: filteredNuggets })
  } else reply.send({ nuggets })
}

export const getOneNuggetHandler: RouteHandler<{
  Params: Params
  Reply: Reply | NuggetNotFound
}> = async function (req, reply) {
  const { nuggetUid } = req.params
  const nugget = nuggets.find((a) => a.uid == nuggetUid)
  if (nugget) reply.send({ nuggets: [nugget] })
  else reply.code(404).send({ error: 'Nugget not found' })
}

export const postNuggetsHandler: RouteHandler<{
  Body: Body
  Reply: Body
}> = async function (req, reply) {
  const newNuggetID = nuggets.length + 1
  const newNugget = {
    id: newNuggetID,
    ...req.body
  }
  nuggets.push(newNugget)

  reply.code(201).header('Location', `/nuggets/${newNuggetID}`).send(newNugget)
}

export const putNuggetsHandler: RouteHandler<{
  Params: Params
  Body: Body
  Reply: NuggetNotFound
}> = async function (req, reply) {
  const { nuggetUid } = req.params
  const nugget = nuggets.find((p) => p.id == nuggetUid)
  if (nugget) {
    nugget.title = req.body.title
    nugget.content = req.body.content
    nugget.tags = req.body.tags
    reply.code(204)
  } else {
    reply.code(404).send({ error: 'Nugget not found' })
  }
}

export const patchNuggetsHandler: RouteHandler<{
  Params: Params
  Body: Body
  Reply: NuggetNotFound
}> = async function (req, reply) {
  const { nuggetUid } = req.params
  const nugget = nuggets.find((p) => p.id == nuggetUid)
  if (nugget) {
    nugget.title = req.body.title
    nugget.content = req.body.content
    nugget.tags = req.body.tags
    reply.code(204)
  } else {
    reply.code(404).send({ error: 'Nugget not found' })
  }
}

export const putNuggetPublishHandler: RouteHandler<{
  Params: Params
  Body: Body
  Reply: NuggetNotFound
}> = async function (req, reply) {
  const { nuggetUid } = req.params
  const nugget = nuggets.find((p) => p.id == nuggetUid)
  if (nugget) {
    nugget.title = req.body.title
    nugget.content = req.body.content
    nugget.tags = req.body.tags
    reply.code(204)
  } else {
    reply.code(404).send({ error: 'Nugget not found' })
  }
}

export const deleteNuggetsHandler: RouteHandler<{
  Params: Params
  Reply: NuggetNotFound
}> = async function (req, reply) {
  const { nuggetUid } = req.params
  const nugget = nuggets.find((p) => p.id == nuggetUid)
  if (nugget) {
    nugget.deleted = true
    reply.code(204)
  } else {
    reply.code(404).send({ error: 'Nugget not found' })
  }
}
