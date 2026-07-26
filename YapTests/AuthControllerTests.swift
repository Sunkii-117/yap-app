import XCTest
@testable import Yap

@MainActor
final class AuthControllerTests: XCTestCase {
    func test_appleSignIn_success_movesToSignedIn() async {
        let mock = MockAuthService(nextResult: .success(.stub))
        let c = AuthController(service: mock)
        await c.signIn(with: .apple)
        XCTAssertTrue(c.isSignedIn)
        XCTAssertEqual(c.currentUser?.id, "user-stub")
        XCTAssertEqual(c.accessToken, "stub-access-token")
    }

    func test_googleSignIn_failure_showsError_staysSignedOut() async {
        let mock = MockAuthService(nextResult: .failure(.network))
        let c = AuthController(service: mock)
        await c.signIn(with: .google)
        XCTAssertFalse(c.isSignedIn)
        XCTAssertNil(c.accessToken)
        guard case .failed(let e) = c.phase else { return XCTFail("expected .failed, got \(c.phase)") }
        XCTAssertEqual(e, .network)
    }

    func test_cancellation_returnsToSignedOut_silently() async {
        let mock = MockAuthService(nextResult: .failure(.cancelled))
        let c = AuthController(service: mock)
        await c.signIn(with: .apple)
        XCTAssertEqual(c.phase, .signedOut, "backing out of the sheet is not an error")
    }

    func test_email_valid_sendsLink_thenAwaits() async {
        let mock = MockAuthService()
        let c = AuthController(service: mock)
        await c.signIn(with: .email, email: "  HI@Yap.App ")
        guard case .awaitingEmailLink(let addr) = c.phase else { return XCTFail("expected awaiting") }
        XCTAssertEqual(addr, "hi@yap.app", "email should be trimmed + lowercased")
        let sent = await mock.sentEmails
        XCTAssertEqual(sent, ["hi@yap.app"])
    }

    func test_email_invalid_rejectedBeforeService() async {
        let mock = MockAuthService()
        let c = AuthController(service: mock)
        await c.signIn(with: .email, email: "not-an-email")
        guard case .failed = c.phase else { return XCTFail("expected .failed") }
        let sent = await mock.sentEmails
        XCTAssertTrue(sent.isEmpty, "invalid email must never reach the service")
    }

    func test_callback_completesSession() async {
        let mock = MockAuthService(nextResult: .success(.stub))
        let c = AuthController(service: mock)
        await c.handleCallback(url: URL(string: "yap://auth-callback#access_token=x")!)
        XCTAssertTrue(c.isSignedIn)
        let seen = await mock.callbackURLs
        XCTAssertEqual(seen.count, 1)
    }

    func test_restore_picksUpPersistedSession() async {
        let mock = MockAuthService(session: .stub)
        let c = AuthController(service: mock)
        await c.restore()
        XCTAssertTrue(c.isSignedIn)
    }

    func test_signOut_clearsSession() async {
        let mock = MockAuthService(session: .stub, nextResult: .success(.stub))
        let c = AuthController(service: mock)
        await c.signIn(with: .apple)
        await c.signOut()
        XCTAssertFalse(c.isSignedIn)
        XCTAssertNil(c.accessToken)
        XCTAssertEqual(c.phase, .signedOut)
        let count = await mock.signOutCount
        XCTAssertEqual(count, 1)
    }

    func test_looksLikeEmail_shape() {
        XCTAssertTrue(AuthController.looksLikeEmail("a@b.co"))
        XCTAssertFalse(AuthController.looksLikeEmail("@b.co"))
        XCTAssertFalse(AuthController.looksLikeEmail("a@bco"))
        XCTAssertFalse(AuthController.looksLikeEmail("a@b."))
        XCTAssertFalse(AuthController.looksLikeEmail("plainstring"))
    }
}
