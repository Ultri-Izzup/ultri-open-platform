import type { FastifySchema } from 'fastify'
import { FromSchema } from 'json-schema-to-ts'

// Shared Schema
export const accountSchema = {
  $id: 'account',
  type: 'object',
  properties: {
    uid: {type: 'string' },
    name: { type: 'string' },
    createdAt: {type: 'string' }
  },
  required: ['name']
} as const

export const accountEditSchema = {
  $id: 'accountEdit',
  type: 'object',
  properties: {
    name: { type: 'string' },
  },
  required: ['name']
} as const

export const accountRoleSchema = {
  $id: 'accountRole',
  type: 'object',
  properties: {
    uid: {type: 'string' },
    name: { type: 'string' },
    createdAt: {type: 'string' },
    permissions: {type: 'object' }
  },
  required: ['name']
} as const

export const accountEditRoleSchema = {
  $id: 'accountRoleEdit',
  type: 'object',
  properties: {
    permissions: {type: 'object' }
  },
  required: ['permissions']
} as const


export const accountGroupSchema = {
  $id: 'accountGroup',
  type: 'object',
  properties: {
    uid: {type: 'string' },
    name: { type: 'string' },
    createdAt: {type: 'string' },
    roles: { type: 'array', items: { type: 'string' }}
  },
  required: ['name']
} as const

export const accountEditGroupSchema = {
  $id: 'accountGroupEdit',
  type: 'object',
  properties: {
    name: { type: 'string' },
    roles: { type: 'array', items: { type: 'string' }}
  },
  required: []
} as const

export const accountEditGroupMemberSchema = {
  $id: 'accountGroupEdit',
  type: 'object',
  properties: {
    name: { type: 'string' },
    roles: { type: 'array', items: { type: 'string' }}
  },
  required: []
} as const

// Not found Schema
export const accountNotFoundSchema = {
  $id: 'accountNotFound',
  type: 'object',
  required: ['error'],
  properties: {
    error: { type: 'string' }
  },
  additionalProperties: false
} as const

export type AccountNotFound = FromSchema<typeof accountNotFoundSchema>

// Params Schema
const paramsSchema = {
  type: 'object',
  required: ['accountUid'],
  properties: {
    accountUid: { type: 'string' }
  },
  additionalProperties: false
} as const

export type Params = FromSchema<typeof paramsSchema>

// Body Schema
export type Body = FromSchema<typeof accountSchema>

// Response Schema
const replySchema = {
  type: 'object',
  properties: {
    accounts: {
      type: 'array',
      items: { $ref: 'account#' }
    }
  },
  additionalProperties: false
} as const

export type Reply = FromSchema<
  typeof replySchema,
  { references: [typeof accountSchema] }
>

/* Get */
export const getAccountsSchema: FastifySchema = {
  tags: ['Accounts'],
  description: 'Get accounts',
  response: {
    200: {
      ...replySchema
    }
  }
}

export const getOneAccountSchema: FastifySchema = {
  tags: ['Accounts'],
  description: 'Get an account by id',
  params: paramsSchema,
  response: {
    200: {
      ...replySchema
    },
    404: {
      description: 'The account was not found',
      $ref: 'accountNotFound#'
    }
  }
}

/* Post */
export const postAccountsSchema: FastifySchema = {
  tags: ['Accounts'],
  description: 'Create a new account',
  body: accountEditSchema,
  response: {
    201: {
      description: 'The account was created',
      headers: {
        Location: {
          type: 'string',
          description: 'URL of the new resource'
        }
      },
      ...accountSchema
    }
  }
}

export const postAccountRoleSchema: FastifySchema = {
  tags: ['Account Roles'],
  description: 'Create a new account role',
  body: accountEditRoleSchema,
  response: {
    201: {
      description: 'The account role was created',
      headers: {
        Location: {
          type: 'string',
          description: 'URL of the new resource'
        }
      },
      ...accountRoleSchema
    }
  }
}

export const postAccountGroupSchema: FastifySchema = {
  tags: ['Account Groups'],
  description: 'Create a new account group',
  body: accountEditGroupSchema,
  response: {
    201: {
      description: 'The account role was created',
      headers: {
        Location: {
          type: 'string',
          description: 'URL of the new resource'
        }
      },
      ...accountGroupSchema
    }
  }
}

export const postAccountGroupMemberSchema: FastifySchema = {
  tags: ['Account Groups'],
  description: 'Add a member to a group',
  body: accountEditGroupMemberSchema,
  response: {
    201: {
      description: 'The member was added to the group',
      headers: {
        Location: {
          type: 'string',
          description: 'URL of the new resource'
        }
      },
      ...accountGroupSchema
    }
  }
}


/* Put */
export const putAccountsSchema: FastifySchema = {
  tags: ['Accounts'],
  description: 'Update an account',
  params: paramsSchema,
  body: accountEditSchema,
  response: {
    204: {
      description: 'The account was updated',
      type: 'null'
    },
    404: {
      description: 'The account was not found',
      $ref: 'accountNotFound#'
    }
  }
}

export const putAccountRoleSchema: FastifySchema = {
  tags: ['Account Roles'],
  description: 'Update an account role',
  params: paramsSchema,
  body: accountEditRoleSchema,
  response: {
    204: {
      description: 'The account role was updated',
      type: 'null'
    },
    404: {
      description: 'The account role was not found',
      $ref: 'accountNotFound#'
    }
  }
}

export const putAccountGroupSchema: FastifySchema = {
  tags: ['Account Groups'],
  description: 'Update an account group',
  params: paramsSchema,
  body: accountEditGroupSchema,
  response: {
    204: {
      description: 'The account group was updated',
      type: 'null'
    },
    404: {
      description: 'The account group was not found',
      $ref: 'accountNotFound#'
    }
  }
}

export const putAccountMemberSchema: FastifySchema = {
  tags: ['Account Member'],
  description: 'Update an account member roles',
  params: paramsSchema,
  body: accountEditGroupSchema,
  response: {
    204: {
      description: 'The account member was updated',
      type: 'null'
    },
    404: {
      description: 'The account member was not found',
      $ref: 'accountNotFound#'
    }
  }
}

/* Delete */
export const deleteAccountsSchema: FastifySchema = {
  tags: ['Accounts'],
  description: 'Delete a account',
  params: paramsSchema,
  response: {
    204: {
      description: 'The account was deleted',
      type: 'null'
    },
    404: {
      description: 'The account was not found',
      $ref: 'accountNotFound#'
    }
  }
}

export const deleteAccountRoleSchema: FastifySchema = {
  tags: ['Account Roles'],
  description: 'Delete an account role',
  params: paramsSchema,
  response: {
    204: {
      description: 'The account role was deleted',
      type: 'null'
    },
    404: {
      description: 'The account role was not found',
      $ref: 'accountNotFound#'
    }
  }
}

export const deleteAccountGroupSchema: FastifySchema = {
  tags: ['Account Groups'],
  description: 'Delete an account group',
  params: paramsSchema,
  response: {
    204: {
      description: 'The account group was deleted',
      type: 'null'
    },
    404: {
      description: 'The account group was not found',
      $ref: 'accountNotFound#'
    }
  }
}

export const deleteAccountMemberSchema: FastifySchema = {
  tags: ['Account Member'],
  description: 'Delete a member from an account',
  params: paramsSchema,
  response: {
    204: {
      description: 'The member was removed from the account',
      type: 'null'
    },
    404: {
      description: 'The account member was not found',
      $ref: 'accountNotFound#'
    }
  }
}

export const deleteAccountGroupMemberSchema: FastifySchema = {
  tags: ['Account Groups'],
  description: 'Delete a member from an account group',
  params: paramsSchema,
  response: {
    204: {
      description: 'The member was removed from the account group',
      type: 'null'
    },
    404: {
      description: 'The account group member was not found',
      $ref: 'accountNotFound#'
    }
  }
}
