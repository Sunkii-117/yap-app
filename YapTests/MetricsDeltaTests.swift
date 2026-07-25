import XCTest
@testable import Yap

final class MetricsDeltaTests: XCTestCase {
    private func metrics(fillers: Int, wpm: Int) -> CoachMetrics {
        CoachMetrics(wordCount: 100, durationSec: 60, wpm: wpm, fillers: [:], fillersTotal: fillers)
    }

    func test_nilWhenNoPrevious() {
        XCTAssertNil(MetricsDelta.between(current: metrics(fillers: 5, wpm: 140), previous: nil))
    }

    func test_computesSignedDeltas() {
        let d = MetricsDelta.between(current: metrics(fillers: 6, wpm: 141),
                                     previous: metrics(fillers: 22, wpm: 172))
        XCTAssertEqual(d?.fillersDelta, -16)
        XCTAssertEqual(d?.wpmDelta, -31)
    }
}
