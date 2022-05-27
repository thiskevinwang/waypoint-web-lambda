import { serve } from "./deps.ts";

// deno run --allow-net main.ts
function handler(req: Request): Response {
  return new Response("Hello from Deno 🦕");
}

serve(handler, {
  port: parseInt(Deno.env.get("PORT") || "5000"),
});
