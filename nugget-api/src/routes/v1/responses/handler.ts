import { type RouteHandler } from 'fastify'
import type { Params, Querystring, Body, Reply, ResponseNotFound } from './schema'
import { responses } from './responses'

export const getResponsesHandler: RouteHandler<{
  Querystring: Querystring
  Reply: Reply
}> = async function (req, reply) {
  const { deleted } = req.query
  if (deleted !== undefined) {
    const filteredResponses = responses.filter((response) => response.deleted === deleted)
    reply.send({ responses: filteredResponses })
  } else reply.send({ responses })
}

export const getOneResponseHandler: RouteHandler<{
  Params: Params
  Reply: Reply | ResponseNotFound
}> = async function (req, reply) {
  const { responseUid } = req.params
  const response = responses.find((a) => a.uid == responseUid)
  if (response) reply.send({ responses: [response] })
  else reply.code(404).send({ error: 'Response not found' })
}

export const postResponsesHandler: RouteHandler<{
  Body: Body
  Reply: Body
}> = async function (req, reply) {
  const newResponseID = responses.length + 1
  const newResponse = {
    id: newResponseID,
    ...req.body
  }
  responses.push(newResponse)

  reply.code(201).header('Location', `/responses/${newResponseID}`).send(newResponse)
}

export const putResponsesHandler: RouteHandler<{
  Params: Params
  Body: Body
  Reply: ResponseNotFound
}> = async function (req, reply) {
  const { responseUid } = req.params
  const response = responses.find((p) => p.id == responseUid)
  if (response) {
    response.title = req.body.title
    response.content = req.body.content
    response.tags = req.body.tags
    reply.code(204)
  } else {
    reply.code(404).send({ error: 'Response not found' })
  }
}

export const deleteResponsesHandler: RouteHandler<{
  Params: Params
  Reply: ResponseNotFound
}> = async function (req, reply) {
  const { responseUid } = req.params
  const response = responses.find((p) => p.id == responseUid)
  if (response) {
    response.deleted = true
    reply.code(204)
  } else {
    reply.code(404).send({ error: 'Response not found' })
  }
}
