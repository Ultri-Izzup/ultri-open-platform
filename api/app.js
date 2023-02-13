import Fastify from "fastify";

// Import global plugins
import config from "./plugins/config.js";
import swagger from "./plugins/swagger.js";
import auth from "./plugins/auth.js";
import redis from "./plugins/redis.js";

// Import routes
import indexRoute from "./routes/index.js";
import healthRoutes from "./routes/health.js";

export default async function appFramework() {
  const fastify = Fastify({ logger: true });
  
  // App config, environment variables are mapped to config.
  // You shouldn't call env vars directly past this point or elsewhere in the code.
  fastify.register(config); 

  // Register Postgres

  // Register Redis
  fastify.register(redis);

  // Register SuperTokens middleware, handles everything under `/auth`
  fastify.register(auth);  

  // Register Swagger
  fastify.register(swagger);


  // Register the default index route.
  // If HTML is desired for the indes it should be handled by the gateway.
  fastify.register(indexRoute);

  // Register the health routes.
  // These should be protected from the public
  fastify.register(healthRoutes);



  await fastify.ready();

  return fastify;
}
