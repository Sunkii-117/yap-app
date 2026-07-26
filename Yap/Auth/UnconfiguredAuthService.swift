import Foundation

/// The fallback `AuthService` when no Supabase creds/SDK are linked (dev / pre-credential
/// state). Every sign-in attempt surfaces `.notConfigured` so the gate shows a clear
/// "sign-in isn't set up yet" message instead of silently doing nothing. `AuthServiceFactory`
/// swaps in `SupabaseAuthService` once the package is present and `YapConfig.supabase` is filled.
struct UnconfiguredAuthService: AuthService {
    func currentSession() async -> AuthSession? { nil }
    func signInWithApple() async throws -> AuthSession { throw AuthError.notConfigured }
    func signInWithGoogle() async throws -> AuthSession { throw AuthError.notConfigured }
    func sendEmailLink(to email: String) async throws { throw AuthError.notConfigured }
    func completeCallback(url: URL) async throws -> AuthSession { throw AuthError.notConfigured }
    func signOut() async throws {}
}
