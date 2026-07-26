import Foundation

/// Which sign-in method the user chose. Apple is native (`AuthenticationServices`);
/// Google + email go through Supabase directly.
enum AuthProvider: String, Sendable, CaseIterable {
    case apple, google, email
}

/// The signed-in user — the minimal shape the app needs. Mirrors a Supabase user.
struct AuthUser: Equatable, Sendable, Identifiable {
    let id: String        // Supabase user UUID
    let email: String?
}

/// An active session: the user plus the access token the coach proxy verifies.
struct AuthSession: Equatable, Sendable {
    let user: AuthUser
    let accessToken: String
    let expiresAt: Date?
}

/// Where the auth flow is right now. Drives the gate UI.
enum AuthPhase: Equatable, Sendable {
    case signedOut
    case authenticating               // provider sheet / network in flight
    case awaitingEmailLink(String)    // magic link sent; waiting for the tap-back
    case signedIn(AuthUser)
    case failed(AuthError)
}

/// User-surfaceable auth failures. `.cancelled` is a no-op (the user backed out); the
/// rest render a message on the gate.
enum AuthError: Error, Equatable, Sendable {
    case cancelled              // user dismissed the sheet — show nothing
    case notConfigured          // no Supabase creds / SDK linked yet (dev state)
    case network                // transport failure
    case invalidCallback        // redirect URL couldn't be turned into a session
    case provider(String)       // provider / SDK message, surfaced verbatim

    var isCancellation: Bool { self == .cancelled }

    /// Copy for the gate. `nil` when nothing should be shown (cancellation).
    var userMessage: String? {
        switch self {
        case .cancelled:      return nil
        case .notConfigured:  return "Sign-in isn't set up on this build yet."
        case .network:        return "Couldn't reach the network. Try again."
        case .invalidCallback:return "That sign-in link didn't work. Try again."
        case .provider(let m):return m
        }
    }
}
