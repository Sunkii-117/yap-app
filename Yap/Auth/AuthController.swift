import Foundation
import Observation

/// Drives the sign-in flow for the UI. Wraps an `AuthService`, exposes the current `phase`
/// and `accessToken`, and turns provider taps / the magic-link callback into state transitions.
/// `@MainActor` because it feeds SwiftUI directly; the service work is awaited off it.
@MainActor
@Observable
final class AuthController {
    private(set) var phase: AuthPhase = .signedOut
    /// Access token for the coach proxy; `nil` unless signed in.
    private(set) var accessToken: String?

    private let service: any AuthService

    init(service: any AuthService) {
        self.service = service
    }

    var currentUser: AuthUser? {
        if case .signedIn(let user) = phase { return user }
        return nil
    }
    var isSignedIn: Bool { currentUser != nil }
    var isBusy: Bool { phase == .authenticating }

    /// Restore any persisted session on launch (the SDK keeps it in the Keychain).
    func restore() async {
        if let session = await service.currentSession() { apply(session) }
    }

    /// Start sign-in for a provider. Apple/Google resolve inline; email sends a magic link and
    /// then waits for the callback. Invalid emails are rejected before the service is touched.
    func signIn(with provider: AuthProvider, email: String? = nil) async {
        switch provider {
        case .apple:
            phase = .authenticating
            do { apply(try await service.signInWithApple()) } catch { fail(error) }
        case .google:
            phase = .authenticating
            do { apply(try await service.signInWithGoogle()) } catch { fail(error) }
        case .email:
            let address = (email ?? "").trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            guard Self.looksLikeEmail(address) else {
                phase = .failed(.provider("Enter a valid email address."))
                return
            }
            phase = .authenticating
            do {
                try await service.sendEmailLink(to: address)
                phase = .awaitingEmailLink(address)
            } catch { fail(error) }
        }
    }

    /// Handle the `yap://auth-callback` redirect (magic link / Google OAuth) → a session.
    func handleCallback(url: URL) async {
        phase = .authenticating
        do { apply(try await service.completeCallback(url: url)) } catch { fail(error) }
    }

    func signOut() async {
        try? await service.signOut()
        accessToken = nil
        phase = .signedOut
    }

    /// Return the gate to its initial state (e.g. "use a different email" after a magic link).
    func reset() {
        if !isSignedIn { phase = .signedOut }
    }

    // MARK: - internals

    private func apply(_ session: AuthSession) {
        accessToken = session.accessToken
        phase = .signedIn(session.user)
    }

    private func fail(_ error: Error) {
        let authError = (error as? AuthError) ?? .provider(String(describing: error))
        // A user backing out of the sheet is not an error — return to the gate quietly.
        phase = authError.isCancellation ? .signedOut : .failed(authError)
    }

    /// Minimal shape check; real validation is Supabase's job when it sends the link.
    static func looksLikeEmail(_ s: String) -> Bool {
        guard let at = s.firstIndex(of: "@"), at != s.startIndex else { return false }
        let domain = s[s.index(after: at)...]
        return domain.contains(".") && !domain.hasPrefix(".") && !domain.hasSuffix(".")
    }
}

/// Chooses the concrete `AuthService`. Extended in M1(f): returns `SupabaseAuthService`
/// when the `Supabase` package is linked and `YapConfig.supabase` is filled; otherwise the
/// `UnconfiguredAuthService` fallback so the app still builds and runs.
enum AuthServiceFactory {
    @MainActor static func make() -> any AuthService {
        #if canImport(Supabase)
        if let config = YapConfig.supabase {
            return SupabaseAuthService(config: config)
        }
        #endif
        return UnconfiguredAuthService()
    }
}
