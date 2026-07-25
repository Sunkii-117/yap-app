import { createServer, type IncomingMessage } from "node:http";
import Anthropic from "@anthropic-ai/sdk";

// Holds the Anthropic key server-side (from ANTHROPIC_API_KEY) so it never ships
// in the app. The app POSTs the already-filled coaching prompt; we relay it to
// Claude and return the raw model text for the client to parse + validate.
const client = new Anthropic(); // reads ANTHROPIC_API_KEY from the environment
const PORT = Number(process.env.PORT ?? 8787);
const MODEL = process.env.COACH_MODEL ?? "claude-opus-4-8";

function readBody(req: IncomingMessage): Promise<string> {
  return new Promise((resolve, reject) => {
    let data = "";
    req.on("data", (chunk) => (data += chunk));
    req.on("end", () => resolve(data));
    req.on("error", reject);
  });
}

const server = createServer(async (req, res) => {
  const json = (status: number, body: unknown) => {
    res.writeHead(status, { "content-type": "application/json" });
    res.end(JSON.stringify(body));
  };

  if (req.method === "GET" && req.url === "/health") {
    return json(200, { ok: true, model: MODEL });
  }

  if (req.method === "POST" && req.url === "/coach") {
    try {
      const { prompt } = JSON.parse(await readBody(req)) as { prompt?: unknown };
      if (typeof prompt !== "string" || prompt.length === 0) {
        return json(400, { error: "missing 'prompt' string" });
      }

      const message = await client.messages.create({
        model: MODEL,
        max_tokens: 1024, // coaching JSON is small
        messages: [{ role: "user", content: prompt }],
      });

      const coaching = message.content
        .filter((b): b is Anthropic.TextBlock => b.type === "text")
        .map((b) => b.text)
        .join("");

      return json(200, { coaching, model: message.model });
    } catch (err) {
      return json(502, { error: err instanceof Error ? err.message : String(err) });
    }
  }

  return json(404, { error: "not found" });
});

server.listen(PORT, () => {
  console.log(`yap coach proxy listening on :${PORT} (model ${MODEL})`);
});
