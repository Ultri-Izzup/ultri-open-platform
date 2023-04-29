import type { FastifySchema } from 'fastify'
import { FromSchema } from 'json-schema-to-ts'

// Shared Schema
export const responseSchema = {
  $id: 'response',
  type: 'object',
  properties: {
    uid: {type: 'string' },
    commentUid: { type: 'string' },
    parentResponseUid: { type: 'string' },
    createdAt: {type: 'string' },
    nuggetUid: {type: 'string' }
  },
  required: ['commentUid', 'nuggetUid']
} as const

export const responseEditSchema = {
  $id: 'response',
  type: 'object',
  properties: {
    uid: {type: 'string' },
    blocks: {type: 'object'}
  },
  required: ['commentUid', 'nuggetUid']
} as const

// Not found Schema
export const responseNotFoundSchema = {
  $id: 'responseNotFound',
  type: 'object',
  required: ['error'],
  properties: {
    error: { type: 'string' }
  },
  additionalProperties: false
} as const

export type ResponseNotFound = FromSchema<typeof responseNotFoundSchema>

// Params Schema
const paramsSchema = {
  type: 'object',
  required: ['responseUid'],
  properties: {
    responseUid: { type: 'string' }
  },
  additionalProperties: false
} as const

export type Params = FromSchema<typeof paramsSchema>

// Body Schema
export type Body = FromSchema<typeof responseSchema>

// Response Schema
const replySchema = {
  type: 'object',
  properties: {
    responses: {
      type: 'array',
      items: { $ref: 'response#' }
    }
  },
  additionalProperties: false
} as const

export type Reply = FromSchema<
  typeof replySchema,
  { references: [typeof responseSchema] }
>

/* Get */
export const getResponsesSchema: FastifySchema = {
  tags: ['Responses'],
  description: 'Get responses',
  response: {
    200: {
      ...replySchema
    }
  }
}

export const getOneResponseSchema: FastifySchema = {
  tags: ['Responses'],
  description: 'Get a response by id',
  params: paramsSchema,
  response: {
    200: {
      ...replySchema
    },
    404: {
      description: 'The response was not found',
      $ref: 'responseNotFound#'
    }
  }
}

/* Post */
export const postResponsesSchema: FastifySchema = {
  tags: ['Responses'],
  description: 'Create a new response',
  body: responseEditSchema,
  response: {
    201: {
      description: 'The response was created',
      headers: {
        Location: {
          type: 'string',
          description: 'URL of the new resource'
        }
      },
      ...responseSchema
    }
  }
}

/* Put */
export const putResponsesSchema: FastifySchema = {
  tags: ['Responses'],
  description: 'Update a response',
  params: paramsSchema,
  body: responseEditSchema,
  response: {
    204: {
      description: 'The response was updated',
      type: 'null'
    },
    404: {
      description: 'The response was not found',
      $ref: 'responseNotFound#'
    }
  }
}

/* Delete */
export const deleteResponsesSchema: FastifySchema = {
  tags: ['Responses'],
  description: 'Delete a response',
  params: paramsSchema,
  response: {
    204: {
      description: 'The response was deleted',
      type: 'null'
    },
    404: {
      description: 'The response was not found',
      $ref: 'responseNotFound#'
    }
  }
}
