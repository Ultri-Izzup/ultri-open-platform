"use strict";
import fp from "fastify-plugin";
import pgPromise from "pg-promise";

const pgp = pgPromise({/* Initialization Options */});

module.exports = fp(function(fastify, opts, done) {
  const db = pgp(fastify.config.POSTGRES_URI);
  fastify.decorate("postgres", db);
  done();
});
