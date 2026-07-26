# Yap Coach Proxy

Thin Node/TS service that holds the Anthropic API key and relays the coaching
prompt to Claude. **No key ships in the app** — the iOS `HTTPCoachBackend` only
knows this proxy's URL.

## Contract
- `POST /coach` — **auth required.** Send `Authorization: Bearer <supabase-access-token>`; body `{ "prompt": "<filled coaching prompt>" }` → `{ "coaching": "<raw model text>", "model": "claude-opus-4-8" }`. The app parses + validates the text (`CoachingParser`).
- `GET /health` — `{ "ok": true, "model": "..." }` (unauthenticated).

## Auth
`/coach` verifies the caller's Supabase session before relaying to Claude (`auth.ts`):
- HS256 signature + expiry check against `SUPABASE_JWT_SECRET` (Supabase's default signing).
- **Fail-closed:** no secret configured → `503`; missing / invalid / expired token → `401`.
- If your project uses **asymmetric** JWTs, swap the `jwtVerify` key for a JWKS set
  (`createRemoteJWKSet(new URL(\`${SUPABASE_URL}/auth/v1/.well-known/jwks.json\`))`) — see `auth.ts`.

Run the auth tests: `npm test`.

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
Target host: **Render** (git-push Web Service, `npm start`) — this is a long-running `node:http`
server, not a serverless function, and Opus coaching calls can run longer than a serverless timeout.
Use the paid Starter instance, not Free, so the first coach call of a session doesn't hit a cold start.
Set `ANTHROPIC_API_KEY` **and** `SUPABASE_JWT_SECRET` as secrets; expose `/coach`. Then set the app's
`yap.proxyURL` to the deployed `/coach` URL. (Rotate the pasted Anthropic key before deploying.)
