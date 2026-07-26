# Auth setup — founder credential drop

Everything in M1 auth is built and tested against mocks. To make sign-in actually work you
need to create the accounts below and paste a few values. Nothing here is a private key — the
Supabase anon key is public by design (row-level security protects data); the real secrets
(Anthropic key, Supabase JWT secret) live only in the proxy.

Estimated time: ~20 minutes.

## 1. Create the Supabase project

1. supabase.com → **New project**. Pick a name/region; save the DB password.
2. **Settings → API** → copy:
   - **Project URL** → `SUPABASE_URL`
   - **anon public** key → `SUPABASE_ANON_KEY`
   - **JWT Secret** → the proxy's `SUPABASE_JWT_SECRET` (server-only, do NOT put in the app)

## 2. Fill the app config

In `project.yml`, under `targets.Yap.settings.base`, set the two client values (safe to commit —
they're public):

```yaml
        SUPABASE_URL: "https://<your-ref>.supabase.co"
        SUPABASE_ANON_KEY: "<anon public key>"
```

Then `xcodegen generate`. (For quick local testing without editing the project you can instead
run the app once and set the `yap.supabaseURL` / `yap.supabaseAnonKey` UserDefaults keys — the
`YapConfig` dev override — but committing them in `project.yml` is the real path.)

## 3. Fill the proxy secret

In `proxy/.env` (gitignored) add:

```
SUPABASE_JWT_SECRET=<JWT Secret from step 1>
```

`POST /coach` fails closed (503) until this is set, and returns 401 for any request without a
valid, unexpired Supabase session token. Verify: `cd proxy && npm test`.

## 4. Enable the providers in Supabase

**Auth → Providers:**

- **Email** — enabled by default. Confirm "Enable email provider" is on. Magic links work out of
  the box (the app calls `signInWithOTP`). No password needed.
- **Apple** — turn on; you'll need a Services ID + key from the Apple Developer portal (step 5).
- **Google** — turn on; create an OAuth client at console.cloud.google.com (OAuth consent screen +
  Web client), paste its Client ID + Secret here. (We use Supabase's web OAuth flow, so no
  GoogleSignIn SDK / iOS client ID is required.)

**Auth → URL Configuration → Redirect URLs:** add `yap://auth-callback`.

## 5. Enable Sign in with Apple (Apple Developer)

The `com.apple.developer.applesignin` entitlement is already in `Yap.entitlements`. You still need
to turn the capability on for the App ID:

1. developer.apple.com → **Certificates, Identifiers & Profiles → Identifiers →** `com.yap.app` →
   check **Sign In with Apple** → Save.
2. Create a **Services ID** + a **Sign in with Apple key**; put those into the Supabase Apple
   provider (step 4). Supabase's Apple provider page lists the exact fields.
3. In Xcode the capability shows up automatically from the entitlement under automatic signing.

## 6. Verify end-to-end (real device)

The simulator can't fully exercise Apple/Google sheets or receive the magic-link redirect reliably,
so do this on a real device:

- Fresh install → **AuthGate** appears → each of Apple / Google / email(magic link) signs in and the
  app advances to onboarding → first yap.
- Kill + relaunch → still signed in (session restored from Keychain).
- (Once the proxy is deployed and `PROXY_URL` set) record a yap → the coach call carries the Bearer
  token and returns real coaching; a signed-out state gets 401.

## Notes / follow-ups

- **Rotate the Anthropic key** you pasted earlier before deploying the proxy.
- Deploy the proxy to **Render** (see `proxy/README.md`), set `ANTHROPIC_API_KEY` +
  `SUPABASE_JWT_SECRET`, then set `PROXY_URL` in `project.yml`.
- If your Supabase project issues **asymmetric** JWTs, switch the proxy to JWKS verification (one
  line in `proxy/auth.ts`, noted there).
- Native Google account-picker (nicer than the web sheet) is an easy later upgrade — add the
  GoogleSignIn SDK + an iOS OAuth client ID and swap `signInWithGoogle()` to `signInWithIdToken`.
- Server-side **profile sync** (goal/interests survive reinstall) is deferred — see the M1 plan.
