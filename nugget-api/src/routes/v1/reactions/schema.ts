import type { FastifySchema } from 'fastify'
import { FromSchema } from 'json-schema-to-ts'

// Shared Schema
export const reactionSchema = {
  $id: 'reaction',
  type: 'object',
  properties: {
    nuggetUid: {type: 'string' },
    createdAt: {type: 'string' },
    reactionType: {type: 'string' }
  },
  required: ['nuggetUid', 'reactionType']
} as const

export const reactionEditSchema = {
  $id: 'reaction',
  type: 'object',
  properties: {
    reactionType: {type: 'string' }
  },
  required: ['reactionType']
} as const

// Not found Schema
export const reactionNotFoundSchema = {
  $id: 'reactionNotFound',
  type: 'object',
  required: ['error'],
  properties: {
    error: { type: 'string' }
  },
  additionalProperties: false
} as const

export type ReactionNotFound = FromSchema<typeof reactionNotFoundSchema>

// Params Schema
const paramsSchema = {
  type: 'object',
  required: ['reactionUid'],
  properties: {
    reactionUid: { type: 'string' }
  },
  additionalProperties: false
} as const

export type Params = FromSchema<typeof paramsSchema>

// Body Schema
export type Body = FromSchema<typeof reactionSchema>

// Response Schema
const replySchema = {
  type: 'object',
  properties: {
    reactions: {
      type: 'array',
      items: { $ref: 'reaction#' }
    }
  },
  additionalProperties: false
} as const

export type Reply = FromSchema<
  typeof replySchema,
  { references: [typeof reactionSchema] }
>

/* Get */
export const getReactionsSchema: FastifySchema = {
  tags: ['Reactions'],
  description: 'Get reactions',
  response: {
    200: {
      ...replySchema
    }
  }
}

export const getOneReactionSchema: FastifySchema = {
  tags: ['Reactions'],
  description: 'Get a reaction by id',
  params: paramsSchema,
  response: {
    200: {
      ...replySchema
    },
    404: {
      description: 'The reaction was not found',
      $ref: 'reactionNotFound#'
    }
  }
}

/* Post */
export const postReactionsSchema: FastifySchema = {
  tags: ['Reactions'],
  description: 'Create a new reaction',
  body: reactionEditSchema,
  response: {
    201: {
      description: 'The reaction was created',
      headers: {
        Location: {
          type: 'string',
          description: 'URL of the new resource'
        }
      },
      ...reactionSchema
    }
  }
}

/* Put */
export const putReactionsSchema: FastifySchema = {
  tags: ['Reactions'],
  description: 'Update a reaction',
  params: paramsSchema,
  body: reactionEditSchema,
  response: {
    204: {
      description: 'The reaction was updated',
      type: 'null'
    },
    404: {
      description: 'The reaction was not found',
      $ref: 'reactionNotFound#'
    }
  }
}

/* Delete */
export const deleteReactionsSchema: FastifySchema = {
  tags: ['Reactions'],
  description: 'Delete a reaction',
  params: paramsSchema,
  response: {
    204: {
      description: 'The reaction was deleted',
      type: 'null'
    },
    404: {
      description: 'The reaction was not found',
      $ref: 'reactionNotFound#'
    }
  }
}
