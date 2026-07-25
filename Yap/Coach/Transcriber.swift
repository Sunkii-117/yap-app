import Foundation
import Speech
import AVFoundation

/// A transcript of a yap. Word timings will be added when filler→moment jumps land
/// (M4); text + duration is what the coach metrics need today.
struct Transcript: Equatable {
    let text: String
    let durationSec: Double
}

/// The transcription seam. On-device Apple `Speech` is the v1 implementation
/// (founder decision 2026-07-25); a word-timestamped cloud ASR can drop in behind
/// this protocol if accuracy falls short — the coach engine only knows `Transcriber`.
protocol Transcriber {
    func transcribe(audioURL: URL) async throws -> Transcript
}

enum TranscriptionError: Error {
    case recognizerUnavailable
    case notAuthorized
    case failed(String)
}

/// On-device transcription via Apple's Speech framework (file-based recognition).
/// Exercised end-to-end in M1 once the record flow produces audio; kept behind the
/// protocol so the rest of the engine is testable without audio/permissions.
struct SpeechTranscriber: Transcriber {
    func transcribe(audioURL: URL) async throws -> Transcript {
        try await requestAuthorization()

        guard let recognizer = SFSpeechRecognizer(), recognizer.isAvailable else {
            throw TranscriptionError.recognizerUnavailable
        }
        let request = SFSpeechURLRecognitionRequest(url: audioURL)
        request.requiresOnDeviceRecognition = true
        request.addsPunctuation = true

        let duration = CMTimeGetSeconds(try await AVURLAsset(url: audioURL).load(.duration))

        let text: String = try await withCheckedThrowingContinuation { continuation in
            var resumed = false
            recognizer.recognitionTask(with: request) { result, error in
                if let error {
                    if !resumed { resumed = true; continuation.resume(throwing: TranscriptionError.failed(error.localizedDescription)) }
                    return
                }
                if let result, result.isFinal, !resumed {
                    resumed = true
                    continuation.resume(returning: result.bestTranscription.formattedString)
                }
            }
        }
        return Transcript(text: text, durationSec: duration)
    }

    private func requestAuthorization() async throws {
        let status = await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { continuation.resume(returning: $0) }
        }
        guard status == .authorized else { throw TranscriptionError.notAuthorized }
    }
}

/// Test/preview double.
struct MockTranscriber: Transcriber {
    let transcript: Transcript
    func transcribe(audioURL: URL) async throws -> Transcript { transcript }
}
