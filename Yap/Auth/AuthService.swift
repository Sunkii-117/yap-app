import Foundation

/// The auth surface the app talks to. The real implementation wraps the Supabase SDK
/// (`SupabaseAuthService`, behind `#if canImport(Supabase)`); tests inject `MockAuthService`;
/// `UnconfiguredAuthService` is the fallback when no SDK/creds are present.
///
/// Apple uses a native identity token exchanged with Supabase; Google is Supabase's OAuth
/// web flow; email is a Supabase magic link. Google + email complete asynchronously via the
/// `yap://auth-callback` redirect, handled by `completeCallback(url:)`.
protocol AuthService: Sendable {
    /// The current session, if any — restored from the SDK's Keychain storage on launch.
    func currentSession() async -> AuthSession?

    /// Native Sign in with Apple: obtain an identity token, exchange it with Supabase.
    func signInWithApple() async throws -> AuthSession

    /// Google via Supabase OAuth (web). Resolves to a session when the callback completes.
    func signInWithGoogle() async throws -> AuthSession

    /// Email magic link: sends the link to `email`. The session arrives later, when the user
    /// taps the link and the app receives the redirect (see `completeCallback(url:)`).
    func sendEmailLink(to email: String) async throws

    /// Turn a `yap://auth-callback` redirect (magic link / OAuth) into a session.
    func completeCallback(url: URL) async throws -> AuthSession

    func signOut() async throws
}
