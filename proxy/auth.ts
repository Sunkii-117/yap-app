import { jwtVerify, errors } from "jose";

export type VerifyResult =
  | { ok: true; userId: string }
  | { ok: false; status: number; error: string };

/**
 * Verify a Supabase access token taken from an `Authorization: Bearer <jwt>` header.
 *
 * HS256 against `SUPABASE_JWT_SECRET` — Supabase's default symmetric signing. Verifies the
 * signature and (via jose) the `exp` claim, and requires a subject. **Fail-closed:** if the
 * secret isn't configured we return 503 rather than letting unauthenticated calls through.
 *
 * (If a project is configured for asymmetric JWTs, swap `jwtVerify(token, key, …)` for a
 *  `createRemoteJWKSet(new URL(`${SUPABASE_URL}/auth/v1/.well-known/jwks.json`))` key — the
 *  rest of this function is unchanged. See README.)
 */
export async function verifyBearer(
  authHeader: string | undefined,
  secret: string | undefined,
): Promise<VerifyResult> {
  if (!secret) {
    return { ok: false, status: 503, error: "auth not configured" };
  }

  const token = bearerToken(authHeader);
  if (!token) {
    return { ok: false, status: 401, error: "missing bearer token" };
  }

  try {
    const key = new TextEncoder().encode(secret);
    const { payload } = await jwtVerify(token, key, { algorithms: ["HS256"] });
    const userId = typeof payload.sub === "string" ? payload.sub : "";
    if (!userId) {
      return { ok: false, status: 401, error: "token missing subject" };
    }
    return { ok: true, userId };
  } catch (err) {
    return { ok: false, status: 401, error: authErrorMessage(err) };
  }
}

/** Extract the token from a `Bearer <token>` header (case-insensitive), else null. */
export function bearerToken(header: string | undefined): string | null {
  if (!header) return null;
  const match = /^Bearer\s+(.+)$/i.exec(header.trim());
  return match ? match[1].trim() : null;
}

function authErrorMessage(err: unknown): string {
  if (err instanceof errors.JWTExpired) return "token expired";
  if (err instanceof errors.JWSSignatureVerificationFailed) return "bad signature";
  if (err instanceof errors.JWTInvalid || err instanceof errors.JWSInvalid) return "malformed token";
  return "invalid token";
}
