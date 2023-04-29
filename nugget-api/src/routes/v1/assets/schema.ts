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

export const assetSchema = {
  $id: 'asset',
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
    assetType: {type: 'string' },
  },
  required: ['assetType']
} as const

export const assetEditSchema = {
  $id: 'assetEdit',
  type: 'object',
  properties: {
    publicTitle: {type: 'string' },
    internalName: {type: 'string' },
    blocks: {type: 'array' , items: blockSchema},
  },
  required: ['name']
} as const

export const assetPublishSchema = {
  $id: 'assetPublish',
  type: 'object',
  properties: {
    pubAt: {type: 'string' },
    unPubAt: {type: 'string' },
  },
  required: ['pubAt','unPubAt']
} as const

// Not found Schema
export const assetNotFoundSchema = {
  $id: 'assetNotFound',
  type: 'object',
  required: ['error'],
  properties: {
    error: { type: 'string' }
  },
  additionalProperties: false
} as const

export type AssetNotFound = FromSchema<typeof assetNotFoundSchema>

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
  required: ['assetUid'],
  properties: {
    assetUid: { type: 'string' }
  },
  additionalProperties: false
} as const

export type Params = FromSchema<typeof paramsSchema>

// Body Schema
export type Body = FromSchema<typeof assetSchema>

// Response Schema
const replySchema = {
  type: 'object',
  properties: {
    assets: {
      type: 'array',
      items: { $ref: 'asset#' }
    }
  },
  additionalProperties: false
} as const

export type Reply = FromSchema<
  typeof replySchema,
  { references: [typeof assetSchema] }
>

/* Get */
export const getAssetsSchema: FastifySchema = {
  tags: ['Assets'],
  description: 'Get assets',
  querystring: querystringSchema,
  response: {
    200: {
      ...replySchema
    }
  }
}

export const getOneAssetSchema: FastifySchema = {
  tags: ['Assets'],
  description: 'Get a asset by id',
  params: paramsSchema,
  response: {
    200: {
      ...replySchema
    },
    404: {
      description: 'The asset was not found',
      $ref: 'assetNotFound#'
    }
  }
}

/* Post */
export const postAssetsSchema: FastifySchema = {
  tags: ['Assets'],
  description: 'Create a new asset',
  body: assetEditSchema,
  response: {
    201: {
      description: 'The asset was created',
      headers: {
        Location: {
          type: 'string',
          description: 'URL of the new resource'
        }
      },
      ...assetSchema
    }
  }
}

/* Put */
export const putAssetsSchema: FastifySchema = {
  tags: ['Assets'],
  description: 'Publish a asset',
  params: paramsSchema,
  body: assetEditSchema,
  response: {
    204: {
      description: 'The asset was updated',
      type: 'null'
    },
    404: {
      description: 'The asset was not found',
      $ref: 'assetNotFound#'
    }
  }
}

export const putAssetPublishSchema: FastifySchema = {
  tags: ['Assets'],
  description: 'Set publishing for a asset',
  params: paramsSchema,
  body: assetPublishSchema,
  response: {
    204: {
      description: 'The asset was updated',
      type: 'null'
    },
    404: {
      description: 'The asset was not found',
      $ref: 'assetNotFound#'
    }
  }
}

/* Delete */
export const deleteAssetsSchema: FastifySchema = {
  tags: ['Assets'],
  description: 'Delete a asset',
  params: paramsSchema,
  response: {
    204: {
      description: 'The asset was deleted',
      type: 'null'
    },
    404: {
      description: 'The asset was not found',
      $ref: 'assetNotFound#'
    }
  }
}
