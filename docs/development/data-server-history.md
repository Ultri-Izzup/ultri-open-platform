# Building the Ultri Nugget Data Server

## Create directory in mono repo.

```sh
mkdir ./nugget-server
```

## Create a Fastify app in the directory

```sh
cd ./nugget-server
npm init
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
npm add fastify fastify-plugin @fastify/autoload 
npm add -D typescript @types/node nodemon esbuild
```

