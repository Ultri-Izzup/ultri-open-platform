import type { FastifyInstance } from 'fastify'
import {
  assetSchema,
  assetNotFoundSchema,
  getAssetsSchema,
  getOneAssetSchema,
  postAssetsSchema,
  putAssetsSchema,
  putAssetPublishSchema,
  deleteAssetsSchema
} from './schema'
import {
  getAssetsHandler,
  getOneAssetHandler,
  postAssetsHandler,
  putAssetsHandler,
  patchAssetsHandler,
  putAssetPublishHandler,
  deleteAssetsHandler
} from './handler'

export default async (fastify: FastifyInstance) => {
  fastify.addSchema(assetSchema)
  fastify.addSchema(assetNotFoundSchema)
  fastify.get('/', { schema: getAssetsSchema }, getAssetsHandler)
  fastify.get('/:assetUid', { schema: getOneAssetSchema }, getOneAssetHandler)
  fastify.post('/', { schema: postAssetsSchema }, postAssetsHandler)
  fastify.put('/:assetUid', { schema: putAssetsSchema }, putAssetsHandler)
  fastify.patch('/:assetUid', { schema: putAssetsSchema }, patchAssetsHandler)
  fastify.put('/:assetUid/publish', { schema: putAssetPublishSchema }, putAssetPublishHandler)
  fastify.delete('/:assetUid', { schema: deleteAssetsSchema }, deleteAssetsHandler)
}
