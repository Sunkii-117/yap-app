import XCTest
@testable import Yap

final class AuthModelsTests: XCTestCase {
    func test_cancellation_isSilent() {
        XCTAssertTrue(AuthError.cancelled.isCancellation)
        XCTAssertNil(AuthError.cancelled.userMessage, "Cancellation must not surface a message")
    }

    func test_nonCancellation_errorsHaveMessages() {
        XCTAssertFalse(AuthError.network.isCancellation)
        XCTAssertNotNil(AuthError.network.userMessage)
        XCTAssertEqual(AuthError.provider("Apple said no").userMessage, "Apple said no")
    }

    func test_unconfiguredService_alwaysThrowsNotConfigured() async {
        let service = UnconfiguredAuthService()
        let session = await service.currentSession()
        XCTAssertNil(session)
        do { _ = try await service.signInWithApple(); XCTFail("expected throw") }
        catch { XCTAssertEqual(error as? AuthError, .notConfigured) }
    }

    func test_mock_returnsScriptedSessionAndRecordsEmail() async throws {
        let mock = MockAuthService()
        let session = try await mock.signInWithApple()
        XCTAssertEqual(session, .stub)

        try await mock.sendEmailLink(to: "hi@yap.app")
        let sent = await mock.sentEmails
        XCTAssertEqual(sent, ["hi@yap.app"])
    }
}
