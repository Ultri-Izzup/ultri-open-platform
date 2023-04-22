# Local Data Server Development

## TL;DR

Edit files in `./nugget-server`, live reload is enabled for local development.

The server is available at <a href="http://localhost:3001" target="_blank" rel="noreferrer">http://localhost:3001</a>

## Basics

The server is written in Typescript. It uses Fastify to aid in maintaing Swagger docs and JSON schema definitions in sync with the code.

The Fastify code accesses the Nugget schema to update and query data. The Nugget schema exposes functions and read-only views that ensure the security of the data the Fastify code accesses. No direct table access or standard SQL queries are used.

The Fastify routes are protected by theb SuperTokens service used in Ultri Auth.

The route handler needs to pass the SuperTokens user info with each call to be successful.

## Database Changes

Many changes to the basic logic implemented by the Data Server must be made in the database.

Those changes should be limited to the set of approved changes, unapproved database schema changes could break things.

### Database Migrations

