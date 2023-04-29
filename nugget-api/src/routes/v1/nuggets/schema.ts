import type { FastifySchema } from 'fastify'
import { FromSchema } from 'json-schema-to-ts'

// Shared Schema
export const blockSchema = {
  $id: 'block',
  type: 'object',
  properties: {
    uid: {type: 'string' },
    createdAt: {type: 'string' },
    updatedAt: {type: 'string' },
    data: {type: 'object'},
    blockType: {type: 'string' },
  },
  required: ['blockType']
} as const

export const nuggetSchema = {
  $id: 'nugget',
  type: 'object',
  properties: {
    uid: {type: 'string' },
    createdAt: {type: 'string' },
    updatedAt: {type: 'string' },
    publicTitle: {type: 'string' },
    internalName: {type: 'string' },
    blocks: {type: 'array' , items: blockSchema},
    pubAt: {type: 'string' },
    unPubAt: {type: 'string' },
    nuggetType: {type: 'string' },
  },
  required: ['nuggetType']
} as const

export const nuggetEditSchema = {
  $id: 'nuggetEdit',
  type: 'object',
  properties: {
    publicTitle: {type: 'string' },
    internalName: {type: 'string' },
    blocks: {type: 'array' , items: blockSchema},
  },
  required: ['name']
} as const

export const nuggetPublishSchema = {
  $id: 'nuggetPublish',
  type: 'object',
  properties: {
    pubAt: {type: 'string' },
    unPubAt: {type: 'string' },
  },
  required: ['pubAt','unPubAt']
} as const

// Not found Schema
export const nuggetNotFoundSchema = {
  $id: 'nuggetNotFound',
  type: 'object',
  required: ['error'],
  properties: {
    error: { type: 'string' }
  },
  additionalProperties: false
} as const

export type NuggetNotFound = FromSchema<typeof nuggetNotFoundSchema>

// Query Schema
const querystringSchema = {
  type: 'object',
  properties: {
    t: { type: 'string' }
  },
  additionalProperties: false
} as const

export type Querystring = FromSchema<typeof querystringSchema>

// Params Schema
const paramsSchema = {
  type: 'object',
  required: ['nuggetUid'],
  properties: {
    nuggetUid: { type: 'string' }
  },
  additionalProperties: false
} as const

export type Params = FromSchema<typeof paramsSchema>

// Body Schema
export type Body = FromSchema<typeof nuggetSchema>

// Response Schema
const replySchema = {
  type: 'object',
  properties: {
    nuggets: {
      type: 'array',
      items: { $ref: 'nugget#' }
    }
  },
  additionalProperties: false
} as const

export type Reply = FromSchema<
  typeof replySchema,
  { references: [typeof nuggetSchema] }
>

/* Get */
export const getNuggetsSchema: FastifySchema = {
  tags: ['Nuggets'],
  description: 'Get nuggets',
  querystring: querystringSchema,
  response: {
    200: {
      ...replySchema
    }
  }
}

export const getOneNuggetSchema: FastifySchema = {
  tags: ['Nuggets'],
  description: 'Get a nugget by id',
  params: paramsSchema,
  response: {
    200: {
      ...replySchema
    },
    404: {
      description: 'The nugget was not found',
      $ref: 'nuggetNotFound#'
    }
  }
}

/* Post */
export const postNuggetsSchema: FastifySchema = {
  tags: ['Nuggets'],
  description: 'Create a new nugget',
  body: nuggetEditSchema,
  response: {
    201: {
      description: 'The nugget was created',
      headers: {
        Location: {
          type: 'string',
          description: 'URL of the new resource'
        }
      },
      ...nuggetSchema
    }
  }
}

/* Put */
export const putNuggetsSchema: FastifySchema = {
  tags: ['Nuggets'],
  description: 'Publish a nugget',
  params: paramsSchema,
  body: nuggetEditSchema,
  response: {
    204: {
      description: 'The nugget was updated',
      type: 'null'
    },
    404: {
      description: 'The nugget was not found',
      $ref: 'nuggetNotFound#'
    }
  }
}

export const putNuggetPublishSchema: FastifySchema = {
  tags: ['Nuggets'],
  description: 'Set publishing for a nugget',
  params: paramsSchema,
  body: nuggetPublishSchema,
  response: {
    204: {
      description: 'The nugget was updated',
      type: 'null'
    },
    404: {
      description: 'The nugget was not found',
      $ref: 'nuggetNotFound#'
    }
  }
}

/* Delete */
export const deleteNuggetsSchema: FastifySchema = {
  tags: ['Nuggets'],
  description: 'Delete a nugget',
  params: paramsSchema,
  response: {
    204: {
      description: 'The nugget was deleted',
      type: 'null'
    },
    404: {
      description: 'The nugget was not found',
      $ref: 'nuggetNotFound#'
    }
  }
}
