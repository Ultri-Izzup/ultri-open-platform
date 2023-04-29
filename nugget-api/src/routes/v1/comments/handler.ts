import { type RouteHandler } from 'fastify'
import type { Params, Querystring, Body, Reply, CommentNotFound } from './schema'
import { comments } from './comments'

export const getCommentsHandler: RouteHandler<{
  Querystring: Querystring
  Reply: Reply
}> = async function (req, reply) {
  const { deleted } = req.query
  if (deleted !== undefined) {
    const filteredComments = comments.filter((comment) => comment.deleted === deleted)
    reply.send({ comments: filteredComments })
  } else reply.send({ comments })
}

export const getOneCommentHandler: RouteHandler<{
  Params: Params
  Reply: Reply | CommentNotFound
}> = async function (req, reply) {
  const { commentUid } = req.params
  const comment = comments.find((a) => a.uid == commentUid)
  if (comment) reply.send({ comments: [comment] })
  else reply.code(404).send({ error: 'Comment not found' })
}

export const postCommentsHandler: RouteHandler<{
  Body: Body
  Reply: Body
}> = async function (req, reply) {
  const newCommentID = comments.length + 1
  const newComment = {
    id: newCommentID,
    ...req.body
  }
  comments.push(newComment)

  reply.code(201).header('Location', `/comments/${newCommentID}`).send(newComment)
}

export const putCommentsHandler: RouteHandler<{
  Params: Params
  Body: Body
  Reply: CommentNotFound
}> = async function (req, reply) {
  const { commentUid } = req.params
  const comment = comments.find((p) => p.id == commentUid)
  if (comment) {
    comment.title = req.body.title
    comment.content = req.body.content
    comment.tags = req.body.tags
    reply.code(204)
  } else {
    reply.code(404).send({ error: 'Comment not found' })
  }
}

export const deleteCommentsHandler: RouteHandler<{
  Params: Params
  Reply: CommentNotFound
}> = async function (req, reply) {
  const { commentUid } = req.params
  const comment = comments.find((p) => p.id == commentUid)
  if (comment) {
    comment.deleted = true
    reply.code(204)
  } else {
    reply.code(404).send({ error: 'Comment not found' })
  }
}
