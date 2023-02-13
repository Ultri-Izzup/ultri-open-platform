# Use Node v18
FROM node:18-alpine as base

# Create API app directory in container
WORKDIR /usr/src/api

FROM base as prereq

# Install global NPM packages
RUN npm install npm@latest fastify-cli -g

RUN apk update && apk upgrade

RUN apk --update add postgresql-client

# set a non privileged user to use when running this image
RUN addgroup -S nodejs && adduser -S nodejs -G nodejs
USER nodejs
# set right (secure) folder permissions
RUN mkdir -p /home/nodejs/app/node_modules && chown -R nodejs:nodejs /home/nodejs/app

WORKDIR /home/nodejs/app

# set default node env
# to be able to run tests (for example in CI), do not set production as environment
ENV NODE_ENV=production

ENV NPM_CONFIG_LOGLEVEL=warn

# copy project definition/dependencies files, for better reuse of layers
COPY --chown=nodejs:nodejs package*.json ./

# install dependencies here, for better reuse of layers
RUN npm install && npm cache clean --force

# Expose the default Fastify port, 3000. 
EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s CMD npm run healthcheck-manual

# We start Fastify from the docker-compose file.
# We volume map the API app files for Fastify in the docker-compose file.
