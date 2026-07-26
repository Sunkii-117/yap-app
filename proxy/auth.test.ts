import { test } from "node:test";
import assert from "node:assert/strict";
import { SignJWT } from "jose";
import { verifyBearer, bearerToken } from "./auth";

const SECRET = "test-secret-at-least-32-bytes-long-string!!";
const key = new TextEncoder().encode(SECRET);
const now = () => Math.floor(Date.now() / 1000);

async function makeToken(opts: { sub?: string; exp?: number; signWith?: Uint8Array } = {}) {
  return new SignJWT({ role: "authenticated" })
    .setProtectedHeader({ alg: "HS256" })
    .setSubject(opts.sub ?? "user-123")
    .setIssuedAt()
    .setExpirationTime(opts.exp ?? now() + 3600)
    .sign(opts.signWith ?? key);
}

test("valid token → ok with userId", async () => {
  const r = await verifyBearer(`Bearer ${await makeToken({ sub: "user-abc" })}`, SECRET);
  assert.equal(r.ok, true);
  if (r.ok) assert.equal(r.userId, "user-abc");
});

test("missing secret → 503 (fail-closed, not 401)", async () => {
  const r = await verifyBearer(`Bearer ${await makeToken()}`, undefined);
  assert.deepEqual(r, { ok: false, status: 503, error: "auth not configured" });
});

test("missing Authorization header → 401", async () => {
  const r = await verifyBearer(undefined, SECRET);
  assert.equal(r.ok, false);
  if (!r.ok) assert.equal(r.status, 401);
});

test("malformed token → 401", async () => {
  const r = await verifyBearer("Bearer not.a.real.jwt", SECRET);
  assert.equal(r.ok, false);
  if (!r.ok) assert.equal(r.status, 401);
});

test("token signed with a different secret → 401", async () => {
  const wrong = new TextEncoder().encode("some-other-secret-value-32-bytes-xxxx");
  const r = await verifyBearer(`Bearer ${await makeToken({ signWith: wrong })}`, SECRET);
  assert.equal(r.ok, false);
  if (!r.ok) assert.equal(r.error, "bad signature");
});

test("expired token → 401", async () => {
  const r = await verifyBearer(`Bearer ${await makeToken({ exp: now() - 60 })}`, SECRET);
  assert.equal(r.ok, false);
  if (!r.ok) assert.equal(r.error, "token expired");
});

test("valid signature but no subject → 401", async () => {
  const noSub = await new SignJWT({ role: "authenticated" })
    .setProtectedHeader({ alg: "HS256" })
    .setIssuedAt()
    .setExpirationTime(now() + 3600)
    .sign(key);
  const r = await verifyBearer(`Bearer ${noSub}`, SECRET);
  assert.equal(r.ok, false);
  if (!r.ok) assert.equal(r.error, "token missing subject");
});

test("bearerToken parsing", () => {
  assert.equal(bearerToken("Bearer abc.def"), "abc.def");
  assert.equal(bearerToken("bearer abc.def"), "abc.def"); // case-insensitive
  assert.equal(bearerToken("Basic abc"), null);
  assert.equal(bearerToken(undefined), null);
  assert.equal(bearerToken(""), null);
});
