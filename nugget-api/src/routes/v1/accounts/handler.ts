import { type RouteHandler } from 'fastify'
import type { Params, Querystring, Body, Reply, AccountNotFound } from './schema'
import { accounts } from './accounts'

export const getAccountsHandler: RouteHandler<{
  Querystring: Querystring
  Reply: Reply
}> = async function (req, reply) {
  const { deleted } = req.query
  if (deleted !== undefined) {
    const filteredAccounts = accounts.filter((account) => account.deleted === deleted)
    reply.send({ accounts: filteredAccounts })
  } else reply.send({ accounts })
}

export const getOneAccountHandler: RouteHandler<{
  Params: Params
  Reply: Reply | AccountNotFound
}> = async function (req, reply) {
  const { accountUid } = req.params
  const account = accounts.find((a) => a.uid == accountUid)
  if (account) reply.send({ accounts: [account] })
  else reply.code(404).send({ error: 'Account not found' })
}

export const postAccountsHandler: RouteHandler<{
  Body: Body
  Reply: Body
}> = async function (req, reply) {
  const newAccountID = accounts.length + 1
  const newAccount = {
    id: newAccountID,
    ...req.body
  }
  accounts.push(newAccount)

  reply.code(201).header('Location', `/accounts/${newAccountID}`).send(newAccount)
}

export const postAccountRoleHandler: RouteHandler<{
  Body: Body
  Reply: Body
}> = async function (req, reply) {
  const newAccountID = accounts.length + 1
  const newAccount = {
    id: newAccountID,
    ...req.body
  }
  accounts.push(newAccount)

  reply.code(201).header('Location', `/accounts/${newAccountID}`).send(newAccount)
}

export const postAccountGroupHandler: RouteHandler<{
  Body: Body
  Reply: Body
}> = async function (req, reply) {
  const newAccountID = accounts.length + 1
  const newAccount = {
    id: newAccountID,
    ...req.body
  }
  accounts.push(newAccount)

  reply.code(201).header('Location', `/accounts/${newAccountID}`).send(newAccount)
}

export const putAccountsHandler: RouteHandler<{
  Params: Params
  Body: Body
  Reply: AccountNotFound
}> = async function (req, reply) {
  const { accountUid } = req.params
  const account = accounts.find((p) => p.id == accountUid)
  if (account) {
    account.title = req.body.title
    account.content = req.body.content
    account.tags = req.body.tags
    reply.code(204)
  } else {
    reply.code(404).send({ error: 'Account not found' })
  }
}

export const putAccountRoleHandler: RouteHandler<{
  Params: Params
  Body: Body
  Reply: AccountNotFound
}> = async function (req, reply) {
  const { accountUid } = req.params
  const account = accounts.find((p) => p.id == accountUid)
  if (account) {
    account.title = req.body.title
    account.content = req.body.content
    account.tags = req.body.tags
    reply.code(204)
  } else {
    reply.code(404).send({ error: 'Account not found' })
  }
}

export const putAccountGroupHandler: RouteHandler<{
  Params: Params
  Body: Body
  Reply: AccountNotFound
}> = async function (req, reply) {
  const { accountUid } = req.params
  const account = accounts.find((p) => p.id == accountUid)
  if (account) {
    account.title = req.body.title
    account.content = req.body.content
    account.tags = req.body.tags
    reply.code(204)
  } else {
    reply.code(404).send({ error: 'Account not found' })
  }
}

export const deleteAccountsHandler: RouteHandler<{
  Params: Params
  Reply: AccountNotFound
}> = async function (req, reply) {
  const { accountUid } = req.params
  const account = accounts.find((p) => p.id == accountUid)
  if (account) {
    account.deleted = true
    reply.code(204)
  } else {
    reply.code(404).send({ error: 'Account not found' })
  }
}

export const deleteAccountRoleHandler: RouteHandler<{
  Params: Params
  Reply: AccountNotFound
}> = async function (req, reply) {
  const { accountUid } = req.params
  const account = accounts.find((p) => p.id == accountUid)
  if (account) {
    account.deleted = true
    reply.code(204)
  } else {
    reply.code(404).send({ error: 'Account not found' })
  }
}

export const deleteAccountGroupHandler: RouteHandler<{
  Params: Params
  Reply: AccountNotFound
}> = async function (req, reply) {
  const { accountUid } = req.params
  const account = accounts.find((p) => p.id == accountUid)
  if (account) {
    account.deleted = true
    reply.code(204)
  } else {
    reply.code(404).send({ error: 'Account not found' })
  }
}
