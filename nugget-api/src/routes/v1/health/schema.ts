import type { FastifySchema } from 'fastify'
import { FromSchema } from 'json-schema-to-ts'

// Shared Schema
export const statusSchema = {
  $id: 'status',
  type: 'object',
  properties: {
    status: { type: 'string' }
  },
  required: ['status']
} as const

// Response Schema
const replySchema = {
  type: 'object',
  properties: {
    status: {
      type: 'string'
    }
  },
  additionalProperties: false
} as const

export type Reply = FromSchema<
  typeof replySchema,
  { references: [typeof statusSchema] }
>

/* Get */
export const getStatusSchema: FastifySchema = {
  tags: ['Health'],
  description: 'Health Check',
  response: {
    200: {
      ...replySchema
    }
  }
}