import { type RouteHandler } from 'fastify'
import type { Reply } from './schema'


export const getBaseHandler: RouteHandler<{
  Reply: Reply
}> = async function (req, reply) {
  reply.send({ status: 'up' })
}

export const getPostgresHandler: RouteHandler<{
  Reply: Reply 
}> = async function (req, reply) {

  const postgres = reply.server.pg;

  const getNow = async () => {

    const client = await postgres.connect();

    try {
        const { rows } = await client.query(
            'SELECT CURRENT_TIMESTAMP'
        )
        // Note: avoid doing expensive computation here, this will block releasing the client
        return rows[0]
      } finally {
        // Release the client immediately after query resolves, or upon error
        client.release()
      }

  }

  let status = "FAIL";

  const dbCheck = await getNow();
  console.log('DBCHECK', dbCheck)

  const currentTime = new Date().getTime();
  const dbCurrentTime = new Date(dbCheck.current_timestamp).getTime();

  const drift = Math.abs(currentTime - dbCurrentTime);

  if (drift < 1000) {
    status = "OK";
  } else {
    status = "DRIFT-DETECTED";
  }

  reply.send({ status: status })
}

export const getRedisHandler: RouteHandler<{
  Reply: Reply 
}> = async function (req, reply) {

  const redis = reply.server.redis;

  let status = "FAIL";

  const resp = await redis.ping();

  if(resp == 'PONG') {
    status = 'OK'
  }

  reply.send({ status: status })
}