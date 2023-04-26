import type { FastifySchema } from 'fastify'
import { FromSchema } from 'json-schema-to-ts'

// Shared Schema
export const commentSchema = {
  $id: 'comment',
  type: 'object',
  properties: {
    uid: {type: 'string' },
    nuggetId: { type: 'string' },
    createdAt: {type: 'string' }
  },
  required: ['name']
} as const

export const commentEditSchema = {
  $id: 'comment',
  type: 'object',
  properties: {
    platformUsername: { type: 'string' },
  },
  required: ['name']
} as const

// Not found Schema
export const commentNotFoundSchema = {
  $id: 'commentNotFound',
  type: 'object',
  required: ['error'],
  properties: {
    error: { type: 'string' }
  },
  additionalProperties: false
} as const

export type CommentNotFound = FromSchema<typeof commentNotFoundSchema>

// Params Schema
const paramsSchema = {
  type: 'object',
  required: ['commentUid'],
  properties: {
    commentUid: { type: 'string' }
  },
  additionalProperties: false
} as const

export type Params = FromSchema<typeof paramsSchema>

// Body Schema
export type Body = FromSchema<typeof commentSchema>

// Response Schema
const replySchema = {
  type: 'object',
  properties: {
    comments: {
      type: 'array',
      items: { $ref: 'comment#' }
    }
  },
  additionalProperties: false
} as const

export type Reply = FromSchema<
  typeof replySchema,
  { references: [typeof commentSchema] }
>

/* Get */
export const getCommentsSchema: FastifySchema = {
  tags: ['Comments'],
  description: 'Get comments',
  response: {
    200: {
      ...replySchema
    }
  }
}

export const getOneCommentSchema: FastifySchema = {
  tags: ['Comments'],
  description: 'Get a comment by id',
  params: paramsSchema,
  response: {
    200: {
      ...replySchema
    },
    404: {
      description: 'The comment was not found',
      $ref: 'commentNotFound#'
    }
  }
}

/* Post */
export const postCommentsSchema: FastifySchema = {
  tags: ['Comments'],
  description: 'Create a new comment',
  body: commentEditSchema,
  response: {
    201: {
      description: 'The comment was created',
      headers: {
        Location: {
          type: 'string',
          description: 'URL of the new resource'
        }
      },
      ...commentSchema
    }
  }
}

/* Put */
export const putCommentsSchema: FastifySchema = {
  tags: ['Comments'],
  description: 'Update a comment',
  params: paramsSchema,
  body: commentEditSchema,
  response: {
    204: {
      description: 'The comment was updated',
      type: 'null'
    },
    404: {
      description: 'The comment was not found',
      $ref: 'commentNotFound#'
    }
  }
}

/* Delete */
export const deleteCommentsSchema: FastifySchema = {
  tags: ['Comments'],
  description: 'Delete a comment',
  params: paramsSchema,
  response: {
    204: {
      description: 'The comment was deleted',
      type: 'null'
    },
    404: {
      description: 'The comment was not found',
      $ref: 'commentNotFound#'
    }
  }
}
