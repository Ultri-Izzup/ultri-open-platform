# Building the Ultri Nugget Data Server

## Create directory in mono repo.

```sh
mkdir ./nugget-api
```

## Create a Fastify app in the directory

```sh
cd ./nugget-api
npm init -y
npm i fastify
npm i -D typescript @types/node
```

## Initialize a TypeScript configuration file:

```sh
npx tsc --init
```

Add base Fastify/Typescript modules.

```sh
npm -i fastify-plugin @fastify/autoload 
npm -i nodemon esbuild
```


Install Fastify Postgres w/ TypeScript support

```sh
npm -i pg @fastify/postgres
npm -i -D typescript @types/pg
```

Install Fastify Redis

```sh
npm -i @fastify/redis
```

Install Fastify helpers

```sh
npm -i @fastify/cors @fastify/env @fastify/formbody
```

Install SuperTokens Node

```sh
npm -i supertokens-node
```
