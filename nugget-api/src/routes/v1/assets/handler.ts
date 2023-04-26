import { type RouteHandler } from 'fastify'
import type { Params, Querystring, Body, Reply, AssetNotFound } from './schema'
import { assets } from './assets'

export const getAssetsHandler: RouteHandler<{
  Querystring: Querystring
  Reply: Reply
}> = async function (req, reply) {
  const { deleted } = req.query
  if (deleted !== undefined) {
    const filteredAssets = assets.filter((asset) => asset.deleted === deleted)
    reply.send({ assets: filteredAssets })
  } else reply.send({ assets })
}

export const getOneAssetHandler: RouteHandler<{
  Params: Params
  Reply: Reply | AssetNotFound
}> = async function (req, reply) {
  const { assetUid } = req.params
  const asset = assets.find((a) => a.uid == assetUid)
  if (asset) reply.send({ assets: [asset] })
  else reply.code(404).send({ error: 'Asset not found' })
}

export const postAssetsHandler: RouteHandler<{
  Body: Body
  Reply: Body
}> = async function (req, reply) {
  const newAssetID = assets.length + 1
  const newAsset = {
    id: newAssetID,
    ...req.body
  }
  assets.push(newAsset)

  reply.code(201).header('Location', `/assets/${newAssetID}`).send(newAsset)
}

export const putAssetsHandler: RouteHandler<{
  Params: Params
  Body: Body
  Reply: AssetNotFound
}> = async function (req, reply) {
  const { assetUid } = req.params
  const asset = assets.find((p) => p.id == assetUid)
  if (asset) {
    asset.title = req.body.title
    asset.content = req.body.content
    asset.tags = req.body.tags
    reply.code(204)
  } else {
    reply.code(404).send({ error: 'Asset not found' })
  }
}

export const patchAssetsHandler: RouteHandler<{
  Params: Params
  Body: Body
  Reply: AssetNotFound
}> = async function (req, reply) {
  const { assetUid } = req.params
  const asset = assets.find((p) => p.id == assetUid)
  if (asset) {
    asset.title = req.body.title
    asset.content = req.body.content
    asset.tags = req.body.tags
    reply.code(204)
  } else {
    reply.code(404).send({ error: 'Asset not found' })
  }
}

export const putAssetPublishHandler: RouteHandler<{
  Params: Params
  Body: Body
  Reply: AssetNotFound
}> = async function (req, reply) {
  const { assetUid } = req.params
  const asset = assets.find((p) => p.id == assetUid)
  if (asset) {
    asset.title = req.body.title
    asset.content = req.body.content
    asset.tags = req.body.tags
    reply.code(204)
  } else {
    reply.code(404).send({ error: 'Asset not found' })
  }
}

export const deleteAssetsHandler: RouteHandler<{
  Params: Params
  Reply: AssetNotFound
}> = async function (req, reply) {
  const { assetUid } = req.params
  const asset = assets.find((p) => p.id == assetUid)
  if (asset) {
    asset.deleted = true
    reply.code(204)
  } else {
    reply.code(404).send({ error: 'Asset not found' })
  }
}
