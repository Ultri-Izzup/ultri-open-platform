import type { FastifySchema } from 'fastify'
import { FromSchema } from 'json-schema-to-ts'

// Shared Schema
export const memberSchema = {
  $id: 'member',
  type: 'object',
  properties: {
    uid: {type: 'string' },
    platformUsername: { type: 'string' },
    createdAt: {type: 'string' }
  },
  required: ['name']
} as const

export const memberEditSchema = {
  $id: 'member',
  type: 'object',
  properties: {
    platformUsername: { type: 'string' },
  },
  required: ['name']
} as const

// Not found Schema
export const memberNotFoundSchema = {
  $id: 'memberNotFound',
  type: 'object',
  required: ['error'],
  properties: {
    error: { type: 'string' }
  },
  additionalProperties: false
} as const

export type MemberNotFound = FromSchema<typeof memberNotFoundSchema>

// Params Schema
const paramsSchema = {
  type: 'object',
  required: ['memberUid'],
  properties: {
    memberUid: { type: 'string' }
  },
  additionalProperties: false
} as const

export type Params = FromSchema<typeof paramsSchema>

// Body Schema
export type Body = FromSchema<typeof memberSchema>

// Response Schema
const replySchema = {
  type: 'object',
  properties: {
    members: {
      type: 'array',
      items: { $ref: 'member#' }
    }
  },
  additionalProperties: false
} as const

export type Reply = FromSchema<
  typeof replySchema,
  { references: [typeof memberSchema] }
>

/* Get */
export const getMembersSchema: FastifySchema = {
  tags: ['Members'],
  description: 'Get members',
  response: {
    200: {
      ...replySchema
    }
  }
}

export const getOneMemberSchema: FastifySchema = {
  tags: ['Members'],
  description: 'Get a member by id',
  params: paramsSchema,
  response: {
    200: {
      ...replySchema
    },
    404: {
      description: 'The member was not found',
      $ref: 'memberNotFound#'
    }
  }
}

/* Post */
export const postMembersSchema: FastifySchema = {
  tags: ['Members'],
  description: 'Create a new member',
  body: memberEditSchema,
  response: {
    201: {
      description: 'The member was created',
      headers: {
        Location: {
          type: 'string',
          description: 'URL of the new resource'
        }
      },
      ...memberSchema
    }
  }
}

/* Put */
export const putMembersSchema: FastifySchema = {
  tags: ['Members'],
  description: 'Update a member',
  params: paramsSchema,
  body: memberEditSchema,
  response: {
    204: {
      description: 'The member was updated',
      type: 'null'
    },
    404: {
      description: 'The member was not found',
      $ref: 'memberNotFound#'
    }
  }
}

/* Delete */
export const deleteMembersSchema: FastifySchema = {
  tags: ['Members'],
  description: 'Delete a member',
  params: paramsSchema,
  response: {
    204: {
      description: 'The member was deleted',
      type: 'null'
    },
    404: {
      description: 'The member was not found',
      $ref: 'memberNotFound#'
    }
  }
}
