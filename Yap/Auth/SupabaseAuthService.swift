#if canImport(Supabase)
import Foundation
import Supabase

/// The real `AuthService`, backed by Supabase. **The only file that imports the SDK** — guarded
/// by `canImport` so the app still builds when the package isn't linked. Apple uses a native
/// identity token exchanged with Supabase; Google uses Supabase's OAuth web flow
/// (`ASWebAuthenticationSession`); email is a magic link. An actor for `Sendable` safety.
actor SupabaseAuthService: AuthService {
    private let client: SupabaseClient
    private let redirectURL: URL

    init(config: SupabaseConfig, redirectURL: URL = YapConfig.authCallbackURL) {
        self.client = SupabaseClient(supabaseURL: config.url, supabaseKey: config.anonKey)
        self.redirectURL = redirectURL
    }

    func currentSession() async -> AuthSession? {
        guard let session = try? await client.auth.session else { return nil }
        return Self.map(session)
    }

    func signInWithApple() async throws -> AuthSession {
        let credential = try await AppleSignInCoordinator.run()
        let session = try await client.auth.signInWithIdToken(
            credentials: .init(provider: .apple, idToken: credential.idToken, nonce: credential.nonce))
        return Self.map(session)
    }

    func signInWithGoogle() async throws -> AuthSession {
        // Supabase presents ASWebAuthenticationSession and returns once the callback fires.
        let session = try await client.auth.signInWithOAuth(provider: .google, redirectTo: redirectURL)
        return Self.map(session)
    }

    func sendEmailLink(to email: String) async throws {
        try await client.auth.signInWithOTP(email: email, redirectTo: redirectURL, shouldCreateUser: true)
    }

    func completeCallback(url: URL) async throws -> AuthSession {
        Self.map(try await client.auth.session(from: url))
    }

    func signOut() async throws {
        try await client.auth.signOut()
    }

    private static func map(_ s: Session) -> AuthSession {
        AuthSession(
            user: AuthUser(id: s.user.id.uuidString, email: s.user.email),
            accessToken: s.accessToken,
            expiresAt: Date(timeIntervalSince1970: s.expiresAt))
    }
}
#endif
