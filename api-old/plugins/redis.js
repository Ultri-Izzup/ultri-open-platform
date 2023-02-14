"use strict";
const fp = require("fastify-plugin");
const fastifyRedis = require('@fastify/redis')

const configuration = require("../config/redis");

module.exports = fp(function(fastify, opts, done) {
  fastify.register(fastifyRedis, { url: configuration.redisUri, /* other redis options */ })
  done();
});
