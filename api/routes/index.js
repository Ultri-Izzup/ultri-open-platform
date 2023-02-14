import fastifyPlugin from "fastify-plugin";

async function indexRoute(server, options) {
  server.get("/", async (request, reply) => {
    return {
      status: "up",
    };
  });
}

export default fastifyPlugin(indexRoute);
