# Yap Coach Proxy

Thin Node/TS service that holds the Anthropic API key and relays the coaching
prompt to Claude. **No key ships in the app** — the iOS `HTTPCoachBackend` only
knows this proxy's URL.

## Contract
- `POST /coach` — body `{ "prompt": "<filled coaching prompt>" }` → `{ "coaching": "<raw model text>", "model": "claude-opus-4-8" }`. The app parses + validates the text (`CoachingParser`).
- `GET /health` — `{ "ok": true, "model": "..." }`.

The app builds the prompt (`CoachPrompt` + authoritative `CoachMetrics`); the proxy just calls the model. Model defaults to `claude-opus-4-8` (override with `COACH_MODEL`).

## Run locally
```bash
cd proxy
npm install
cp .env.example .env   # add your ANTHROPIC_API_KEY
ANTHROPIC_API_KEY=sk-ant-... npm start   # or: set it in .env and `npm start`
```
Point the app's `HTTPCoachBackend(endpoint:)` at `http://localhost:8787/coach` for the simulator.

## Deploy (later)
Any Node host (Vercel/Cloudflare Workers/Fly/Render). Set `ANTHROPIC_API_KEY` as a secret; expose `/coach`. Then point the app at the deployed URL.
