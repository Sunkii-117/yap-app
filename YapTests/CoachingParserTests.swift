import XCTest
@testable import Yap

final class CoachingParserTests: XCTestCase {
    func test_parsesCleanJSON() throws {
        let c = try CoachingParser.parse(CoachFixtures.validCoachingJSON)
        XCTAssertEqual(c.score, 78)
        XCTAssertEqual(c.tips.count, 3)
        XCTAssertFalse(c.highlight.isEmpty)
        XCTAssertFalse(c.deltaNote.isEmpty)
    }

    func test_stripsCodeFencesAndSurroundingProse() throws {
        let wrapped = "Here you go:\n```json\n\(CoachFixtures.validCoachingJSON)\n```\nHope that helps!"
        XCTAssertEqual(try CoachingParser.parse(wrapped).score, 78)
    }

    func test_throwsOnNonJSON() {
        XCTAssertThrowsError(try CoachingParser.parse("sorry, I can't do that")) { error in
            XCTAssertEqual(error as? CoachingError, .notJSON)
        }
    }

    func test_throwsOnScoreOutOfRange() {
        let bad = #"{"score": 250, "delta_note": "x", "tips": ["a", "b"], "highlight": "h"}"#
        XCTAssertThrowsError(try CoachingParser.parse(bad))
    }

    func test_throwsOnTooFewTips() {
        let bad = #"{"score": 50, "delta_note": "x", "tips": ["only one"], "highlight": "h"}"#
        XCTAssertThrowsError(try CoachingParser.parse(bad))
    }

    func test_throwsOnMissingKey() {
        let bad = #"{"score": 50, "tips": ["a", "b"], "highlight": "h"}"# // no delta_note
        XCTAssertThrowsError(try CoachingParser.parse(bad))
    }
}
