#if canImport(Supabase)
import AuthenticationServices
import CryptoKit
import Foundation
import UIKit

/// Runs the native Sign in with Apple flow and returns the identity token + the raw nonce to hand
/// to Supabase's `signInWithIdToken`. Apple receives the SHA256 of the nonce; Supabase receives the
/// raw nonce (it re-hashes and compares). `@MainActor` because it drives `ASAuthorizationController`.
@MainActor
final class AppleSignInCoordinator: NSObject {
    struct Credential { let idToken: String; let nonce: String }

    /// Convenience: run one flow to completion. The instance is retained by the async frame
    /// (which is why the delegate callbacks still fire) until the continuation resumes.
    static func run() async throws -> Credential {
        try await AppleSignInCoordinator().run()
    }

    private var continuation: CheckedContinuation<Credential, Error>?
    private let rawNonce = AppleSignInCoordinator.randomNonce()

    func run() async throws -> Credential {
        try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.email]
            request.nonce = Self.sha256(rawNonce)
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        }
    }

    private func finish(_ result: Result<Credential, Error>) {
        continuation?.resume(with: result)
        continuation = nil
    }

    // MARK: - nonce

    private static func randomNonce(length: Int = 32) -> String {
        let charset = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-._") // 64
        var result = ""
        var remaining = length
        while remaining > 0 {
            for byte in (0..<16).map({ _ in UInt8.random(in: 0...255) }) where remaining > 0 {
                if Int(byte) < charset.count {          // reject high bytes to avoid modulo bias
                    result.append(charset[Int(byte)])
                    remaining -= 1
                }
            }
        }
        return result
    }

    private static func sha256(_ input: String) -> String {
        SHA256.hash(data: Data(input.utf8)).map { String(format: "%02x", $0) }.joined()
    }
}

extension AppleSignInCoordinator: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        guard
            let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
            let tokenData = credential.identityToken,
            let idToken = String(data: tokenData, encoding: .utf8)
        else {
            finish(.failure(AuthError.provider("Apple didn't return an identity token.")))
            return
        }
        finish(.success(Credential(idToken: idToken, nonce: rawNonce)))
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        if let asError = error as? ASAuthorizationError, asError.code == .canceled {
            finish(.failure(AuthError.cancelled))
        } else {
            finish(.failure(AuthError.provider(error.localizedDescription)))
        }
    }
}

extension AppleSignInCoordinator: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
        let window = scenes.flatMap(\.windows).first(where: \.isKeyWindow) ?? scenes.first?.windows.first
        return window ?? ASPresentationAnchor()
    }
}
#endif
