// Import required packages
import * as restify from "restify";
import * as path from 'path';

// This bot's adapter
import adapter from "./adapter";

// This bot's main dialog.
import app from "./app/app";

// Create HTTP server.
const server = restify.createServer();
server.use(restify.plugins.bodyParser());

server.listen(process.env.port || process.env.PORT || 3978, () => {
  console.log(`\nBot Started, ${server.name} listening to ${server.url}`);
});

server.get(
  '/auth-:name(start|end).html',
  restify.plugins.serveStatic({
    directory: path.join(__dirname, 'public')
  })
);

// Listen for incoming server requests.
server.post("/api/messages", async (req, res) => {
  // Route received a request to adapter for processing
  await adapter.process(req, res as any, async (context) => {
    // Dispatch to application for routing
    await app.run(context);
  });
});
