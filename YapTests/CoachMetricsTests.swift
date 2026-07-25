import XCTest
@testable import Yap

final class CoachMetricsTests: XCTestCase {
    func test_fillerTotalsAndWPM_matchS1Baseline() {
        for s in CoachFixtures.all {
            let m = CoachMetrics.compute(transcript: s.transcript, durationSec: s.durationSec)
            XCTAssertEqual(m.fillersTotal, s.expectedFillersTotal, "\(s.id) filler total")
            XCTAssertEqual(m.wpm, s.expectedWPM, "\(s.id) wpm")
        }
    }

    func test_emptyTranscript_isAllZero() {
        let m = CoachMetrics.compute(transcript: "", durationSec: 60)
        XCTAssertEqual(m.wordCount, 0)
        XCTAssertEqual(m.fillersTotal, 0)
        XCTAssertEqual(m.wpm, 0)
    }

    func test_zeroDuration_wpmIsZeroNotCrash() {
        let m = CoachMetrics.compute(transcript: "one two three", durationSec: 0)
        XCTAssertEqual(m.wpm, 0)
        XCTAssertEqual(m.wordCount, 3)
    }
}
