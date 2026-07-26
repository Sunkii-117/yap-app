import Foundation
@testable import Yap

/// Scriptable test double for `AuthService`. An actor so it's `Sendable` under Swift 6
/// strict concurrency; the controller awaits it exactly like the real service.
actor MockAuthService: AuthService {
    enum Outcome: Sendable { case success(AuthSession), failure(AuthError) }

    private(set) var session: AuthSession?
    private var nextResult: Outcome
    private(set) var sentEmails: [String] = []
    private(set) var callbackURLs: [URL] = []
    private(set) var signOutCount = 0

    init(session: AuthSession? = nil, nextResult: Outcome = .success(.stub)) {
        self.session = session
        self.nextResult = nextResult
    }

    func setNextResult(_ outcome: Outcome) { nextResult = outcome }
    func setSession(_ s: AuthSession?) { session = s }

    func currentSession() async -> AuthSession? { session }
    func signInWithApple() async throws -> AuthSession { try resolve() }
    func signInWithGoogle() async throws -> AuthSession { try resolve() }

    func sendEmailLink(to email: String) async throws {
        sentEmails.append(email)
        if case .failure(let e) = nextResult { throw e }
    }

    func completeCallback(url: URL) async throws -> AuthSession {
        callbackURLs.append(url)
        return try resolve()
    }

    func signOut() async throws {
        signOutCount += 1
        session = nil
    }

    private func resolve() throws -> AuthSession {
        switch nextResult {
        case .success(let s): session = s; return s
        case .failure(let e): throw e
        }
    }
}

extension AuthSession {
    /// A ready-made valid session for tests/fixtures. Expiry far in the future.
    static let stub = AuthSession(
        user: AuthUser(id: "user-stub", email: "yapper@example.com"),
        accessToken: "stub-access-token",
        expiresAt: Date(timeIntervalSince1970: 4_102_444_800)) // 2100-01-01
}
