import type { FastifySchema } from 'fastify'
import { FromSchema } from 'json-schema-to-ts'

// Shared Schema
export const invitationSchema = {
  $id: 'invitation',
  type: 'object',
  properties: {
    uid: {type: 'string' },
    platformUsername: { type: 'string' },
    createdAt: {type: 'string' }
  },
  required: ['name']
} as const

export const invitationEditSchema = {
  $id: 'invitation',
  type: 'object',
  properties: {
    platformUsername: { type: 'string' },
  },
  required: ['name']
} as const

// Not found Schema
export const invitationNotFoundSchema = {
  $id: 'invitationNotFound',
  type: 'object',
  required: ['error'],
  properties: {
    error: { type: 'string' }
  },
  additionalProperties: false
} as const

export type InvitationNotFound = FromSchema<typeof invitationNotFoundSchema>

// Params Schema
const paramsSchema = {
  type: 'object',
  required: ['invitationUid'],
  properties: {
    invitationUid: { type: 'string' }
  },
  additionalProperties: false
} as const

export type Params = FromSchema<typeof paramsSchema>

// Body Schema
export type Body = FromSchema<typeof invitationSchema>

// Response Schema
const replySchema = {
  type: 'object',
  properties: {
    invitations: {
      type: 'array',
      items: { $ref: 'invitation#' }
    }
  },
  additionalProperties: false
} as const

export type Reply = FromSchema<
  typeof replySchema,
  { references: [typeof invitationSchema] }
>

/* Get */
export const getInvitationsSchema: FastifySchema = {
  tags: ['Invitations'],
  description: 'Get invitations',
  response: {
    200: {
      ...replySchema
    }
  }
}

export const getOneInvitationSchema: FastifySchema = {
  tags: ['Invitations'],
  description: 'Get a invitation by id',
  params: paramsSchema,
  response: {
    200: {
      ...replySchema
    },
    404: {
      description: 'The invitation was not found',
      $ref: 'invitationNotFound#'
    }
  }
}

/* Post */
export const postInvitationsSchema: FastifySchema = {
  tags: ['Invitations'],
  description: 'Create a new invitation',
  body: invitationEditSchema,
  response: {
    201: {
      description: 'The invitation was created',
      headers: {
        Location: {
          type: 'string',
          description: 'URL of the new resource'
        }
      },
      ...invitationSchema
    }
  }
}

/* Put */
export const putInvitationsSchema: FastifySchema = {
  tags: ['Invitations'],
  description: 'Update a invitation',
  params: paramsSchema,
  body: invitationEditSchema,
  response: {
    204: {
      description: 'The invitation was updated',
      type: 'null'
    },
    404: {
      description: 'The invitation was not found',
      $ref: 'invitationNotFound#'
    }
  }
}

/* Delete */
export const deleteInvitationsSchema: FastifySchema = {
  tags: ['Invitations'],
  description: 'Delete a invitation',
  params: paramsSchema,
  response: {
    204: {
      description: 'The invitation was deleted',
      type: 'null'
    },
    404: {
      description: 'The invitation was not found',
      $ref: 'invitationNotFound#'
    }
  }
}
