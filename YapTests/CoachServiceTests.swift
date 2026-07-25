import XCTest
@testable import Yap

final class CoachServiceTests: XCTestCase {
    private struct MockBackend: CoachBackend {
        let response: String
        func coach(prompt: String) async throws -> String { response }
    }

    func test_endToEnd_computesMetricsParsesCoachingAndDelta() async throws {
        let service = CoachService(backend: MockBackend(response: CoachFixtures.validCoachingJSON))
        let prev = CoachMetrics(wordCount: 150, durationSec: 60, wpm: 172, fillers: [:], fillersTotal: 22)
        let result = try await service.coach(transcript: CoachFixtures.s1.transcript,
                                             durationSec: 61, previous: prev)
        XCTAssertEqual(result.metrics.fillersTotal, 17)      // exact, from code
        XCTAssertEqual(result.coaching.score, 78)            // from (mocked) LLM
        XCTAssertEqual(result.delta?.fillersDelta, 17 - 22)  // -5, deterministic
    }

    func test_firstYap_hasNoDelta() async throws {
        let service = CoachService(backend: MockBackend(response: CoachFixtures.validCoachingJSON))
        let result = try await service.coach(transcript: CoachFixtures.s2.transcript,
                                             durationSec: 57, previous: nil)
        XCTAssertNil(result.delta)
    }

    func test_malformedBackendOutput_throws() async {
        let service = CoachService(backend: MockBackend(response: "the model rambled, no json here"))
        do {
            _ = try await service.coach(transcript: "hi there", durationSec: 10, previous: nil)
            XCTFail("expected a parse error")
        } catch {
            // expected — malformed output surfaces as an error, not garbage
        }
    }

    func test_promptCarriesAuthoritativeMetrics() {
        let m = CoachMetrics.compute(transcript: CoachFixtures.s1.transcript, durationSec: 61)
        let prompt = CoachPrompt.filled(transcript: CoachFixtures.s1.transcript,
                                        metricsJSON: m.encodedJSON(), previous: "none (first yap)")
        XCTAssertTrue(prompt.contains("\"fillers_total\":17"))
        XCTAssertTrue(prompt.contains("authoritative"))
    }
}
