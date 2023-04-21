# Installing the Ultri Open Platform

You must first decide where and how you will host your data and cache as that is required in configuring the docker containers.

## Persistence

### Database - Postgres

Postgres is required. It provides an incredibly rich feature set in an open source offering. This is key to creating portable apps and avoiding vendor lockin.

### Data - Files - S3

File storage is optional, any basic S3 compliant service will work.

### Cache - Redis

Caching is optional.

## Installing the Ultri Nugget Server 

You need to provide the correct `.env` variables for the services required.

* Postgres
* Redis (optional)
* File Storage (optional, MinIO provided)
* SMTP service (SMTP4Dev used for development)

Once configured, it is a simple `docker compose up` to start the services.

### Protecting the Nugget Server

The Nugget Server needs to be behind an API Gateway of some sort. We provide the Ultri Gateway Server, builty on top of OpenResty/Nginx.

We also provide a guide for AWS using an API Gateway or an ALB, eithere using WAF.

## Installing the Frontend

A TypeScript Vue3 frontend using Quasar is provided. It is a static web site and can be deployed to any static hosting service. Netlify is an option we highly recommend.

### Building the User Interface

Build the Quasar single page app (SPA). 

```sh
cd ./frontend
quasar build -t spa
```

The files will be in `./dist/spa, copy those to your hosting provider. You may need to configure the hosting service to serve the correct default page. This is an example for Netlify:

(Need screenshot and copyable text)

You can use "$ quasar serve" command to create a web server, both for testing or production. Type "$ quasar serve -h" for parameters. Also, an npm script (usually named "start") can be added for deployment environments. If you're using Vue Router "history" mode, don't forget to specify the "--history" parameter: "$ quasar serve --history"





