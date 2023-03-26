import Fastify from "fastify";

// Import global plugins
import config from "./plugins/config.js";
import auth from "./plugins/auth.js";
import swagger from "./plugins/swagger.js";
import redis from "./plugins/redis.js";
import postgres from "./plugins/postgres.js";

// Import routes
import indexRoute from "./routes/index.js";
import healthRoutes from "./routes/health.js";
import memberRoutes from "./routes/member.js";
import nuggetRoutes from "./routes/nugget.js";
import accountRoutes from "./routes/account.js";


export default async function appFramework() {
  const fastify = Fastify({ logger: true });
  
  // App config, environment variables are mapped to config.
  // You shouldn't call env vars directly past this point or elsewhere in the code.
  fastify.register(config); 

  // Postgres
  fastify.register(postgres);

  // Redis
  fastify.register(redis);

  // SuperTokens middleware, handles everything under `/auth`
  fastify.register(auth);  

  // Swagger
  fastify.register(swagger);


  // Default index route.
  // If HTML is desired for the indes it should be handled by the gateway.
  fastify.register(indexRoute);

  // Health routes. These should be protected from the public
  fastify.register(healthRoutes);

  // Member routes. These routes are protected.
  fastify.register(memberRoutes);

  // Nugget routes. These routes are protected.
  fastify.register(nuggetRoutes);

  // Nugget routes. These routes are protected.
  fastify.register(accountRoutes);

  await fastify.ready();

  return fastify;
}
