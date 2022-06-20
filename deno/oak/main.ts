import { Application, Router } from "./deps.ts";

const router = new Router();
router.get("/", ({ response }) => {
	response.body = `<!DOCTYPE html>
  <html>
    <head>
      <title>Hello from Deno 🦕 + Oak 🌳!</title>
      <meta name="color-scheme" content="light dark">
    </head>
    <body>
      <h3>Hello from Deno 🦕 + Oak 🌳!</h3>
      <p>Visit <a href="/ping">/ping</a></p>
    </body>
  </html>
        `;
});

router.get("/ping", ({ response }) => {
	response.body = "pong";
});

const app = new Application();
app.use(router.routes());
app.use(router.allowedMethods());

const PORT = parseInt(Deno.env.get("PORT") || "5000");

app.addEventListener("listen", (e) =>
	console.log(`Listening on http://localhost:${PORT}`)
);
await app.listen({ port: PORT });
