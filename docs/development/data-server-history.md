# Building the Ultri Nugget Data Server

## Create directory in mono repo.

```sh
mkdir ./nugget-server
```

## Create a Fastify app in the directory

```sh
cd ./nugget-server
yarn init
```
Enter sensible data for now.

```
{
  "name": "nugget-data-server",
  "version": "0.1.0",
  "description": "Nugget Data Server",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "author": "Brian Winkers",
  "license": "MIT"
}
```

Add base Fastify/Typescript modules.

```sh
yarn add fastify fastify-plugin @fastify/autoload 
yarn add -D typescript @types/node nodemon esbuild
```


Install Fastify Postgres w/ TypeScript support

```sh
yarn add pg @fastify/postgres
yarn add -D typescript @types/pg
```

Install Fastify Redis

```sh
yarn add @fastify/redis
```

Install Fastify helpers

```sh
yarn add @fastify/cors @fastify/env @fastify/formbody
```

Install SuperTokens Node

```sh
yarn add supertokens-node
```
