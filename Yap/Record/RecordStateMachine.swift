import Foundation

/// The record → coach lifecycle. Kept as a small pure state machine so the
/// transitions are unit-testable independently of `AVAudioRecorder`/`Speech`.
enum RecordState: Equatable {
    case idle
    case recording
    case stopped
    case transcribing
    case scored
    case permissionDenied
    case failed(String)
}

struct RecordStateMachine {
    private(set) var state: RecordState = .idle

    mutating func startRecording() {
        guard state == .idle || state == .stopped || state == .scored else { return }
        state = .recording
    }

    mutating func stopRecording() {
        guard state == .recording else { return }
        state = .stopped
    }

    mutating func beginTranscribing() {
        guard state == .stopped else { return }
        state = .transcribing
    }

    mutating func finishScoring() {
        guard state == .transcribing else { return }
        state = .scored
    }

    mutating func denyPermission() { state = .permissionDenied }
    mutating func fail(_ message: String) { state = .failed(message) }
    mutating func reset() { state = .idle }
}
