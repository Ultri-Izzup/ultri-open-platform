
"use strict";
import fp from "fastify-plugin";
import fastifyRedis from "@fastify/redis";

export default fp(async (fastify, opts, done) => {


fastify.register(fastifyRedis, { 
    host: 'redis', 
    port: 6379
  })

  done()

});