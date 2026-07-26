import XCTest
@testable import Yap

final class HTTPCoachBackendTests: XCTestCase {
    override func tearDown() { StubURLProtocol.handler = nil; super.tearDown() }

    private func stubbedSession() -> URLSession {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [StubURLProtocol.self]
        return URLSession(configuration: config)
    }

    private func backend() -> HTTPCoachBackend {
        HTTPCoachBackend(endpoint: URL(string: "https://proxy.test/coach")!, session: stubbedSession())
    }

    func test_parsesCoachingFrom200() async throws {
        StubURLProtocol.handler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let data = try JSONSerialization.data(withJSONObject: ["coaching": CoachFixtures.validCoachingJSON])
            return (response, data)
        }
        let raw = try await backend().coach(prompt: "hello")
        XCTAssertEqual(try CoachingParser.parse(raw).score, 78) // round-trips through the parser
    }

    /// Holds a captured header across the URLProtocol thread hop without a Sendable warning.
    private final class Box: @unchecked Sendable { var auth: String? = "unset" }

    func test_attachesBearerToken_whenPresent() async throws {
        let box = Box()
        StubURLProtocol.handler = { request in
            box.auth = request.value(forHTTPHeaderField: "Authorization")
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let data = try JSONSerialization.data(withJSONObject: ["coaching": CoachFixtures.validCoachingJSON])
            return (response, data)
        }
        let backend = HTTPCoachBackend(endpoint: URL(string: "https://proxy.test/coach")!,
                                       session: stubbedSession(), accessToken: "tok-123")
        _ = try await backend.coach(prompt: "hi")
        XCTAssertEqual(box.auth, "Bearer tok-123")
    }

    func test_noAuthHeader_whenTokenNil() async throws {
        let box = Box()
        StubURLProtocol.handler = { request in
            box.auth = request.value(forHTTPHeaderField: "Authorization")
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let data = try JSONSerialization.data(withJSONObject: ["coaching": CoachFixtures.validCoachingJSON])
            return (response, data)
        }
        _ = try await backend().coach(prompt: "hi") // no accessToken
        XCTAssertNil(box.auth, "no token → no Authorization header")
    }

    func test_throwsOnNon2xx() async {
        StubURLProtocol.handler = { request in
            (HTTPURLResponse(url: request.url!, statusCode: 502, httpVersion: nil, headerFields: nil)!, Data())
        }
        do {
            _ = try await backend().coach(prompt: "x")
            XCTFail("expected a bad-status error")
        } catch {
            XCTAssertEqual(error as? HTTPCoachBackend.BackendError, .badStatus(502))
        }
    }
}
