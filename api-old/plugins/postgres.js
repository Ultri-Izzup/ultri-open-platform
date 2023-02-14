"use strict";
const fp = require("fastify-plugin");
const pgp = require("pg-promise")();

const configuration = require("../config/postgres");

module.exports = fp(function(fastify, opts, done) {
  const db = pgp(configuration.postgresUri);
  fastify.decorate("postgres", db);
  done();
});
