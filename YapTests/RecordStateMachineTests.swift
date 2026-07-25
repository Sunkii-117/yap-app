import XCTest
@testable import Yap

final class RecordStateMachineTests: XCTestCase {
    func test_happyPath_idleToScored() {
        var m = RecordStateMachine()
        XCTAssertEqual(m.state, .idle)
        m.startRecording();    XCTAssertEqual(m.state, .recording)
        m.stopRecording();     XCTAssertEqual(m.state, .stopped)
        m.beginTranscribing(); XCTAssertEqual(m.state, .transcribing)
        m.finishScoring();     XCTAssertEqual(m.state, .scored)
    }

    func test_invalidTransitions_areIgnored() {
        var m = RecordStateMachine()
        m.stopRecording()      // can't stop from idle
        XCTAssertEqual(m.state, .idle)
        m.beginTranscribing()  // can't transcribe from idle
        XCTAssertEqual(m.state, .idle)
        m.startRecording()
        m.finishScoring()      // can't score from recording
        XCTAssertEqual(m.state, .recording)
    }

    func test_canStartAgainAfterScored() {
        var m = RecordStateMachine()
        m.startRecording(); m.stopRecording(); m.beginTranscribing(); m.finishScoring()
        m.startRecording()
        XCTAssertEqual(m.state, .recording)
    }

    func test_permissionDeniedAndFailure() {
        var m = RecordStateMachine()
        m.denyPermission()
        XCTAssertEqual(m.state, .permissionDenied)
        m.reset(); XCTAssertEqual(m.state, .idle)
        m.fail("boom")
        XCTAssertEqual(m.state, .failed("boom"))
    }
}
