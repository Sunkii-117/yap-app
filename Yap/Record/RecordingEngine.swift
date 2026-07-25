import Foundation
import AVFoundation

/// Real audio capture (design doc §4.3 / M1). Requests mic permission, records to an
/// `.m4a` in the app container, and publishes state + elapsed time for the studio UI.
/// The state mirrors `RecordStateMachine` (which is unit-tested separately).
@MainActor
final class RecordingEngine: NSObject, ObservableObject, AVAudioRecorderDelegate {
    @Published private(set) var state: RecordState = .idle
    @Published private(set) var elapsed: Double = 0
    private(set) var fileName: String?

    private var recorder: AVAudioRecorder?
    private var timer: Timer?

    var audioURL: URL? { fileName.map(AudioStore.url(for:)) }

    func toggle() {
        switch state {
        case .idle, .stopped, .scored: requestPermissionAndStart()
        case .recording:               stop()
        default:                       break
        }
    }

    func requestPermissionAndStart() {
        AVAudioApplication.requestRecordPermission { [weak self] granted in
            Task { @MainActor in
                guard let self else { return }
                if granted { self.start() } else { self.state = .permissionDenied }
            }
        }
    }

    private func start() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true)

            let name = AudioStore.newFileName()
            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44_100,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
            ]
            let rec = try AVAudioRecorder(url: AudioStore.url(for: name), settings: settings)
            rec.delegate = self
            rec.record()

            recorder = rec
            fileName = name
            elapsed = 0
            state = .recording

            timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
                Task { @MainActor in
                    guard let self, let rec = self.recorder, rec.isRecording else { return }
                    self.elapsed = rec.currentTime
                }
            }
        } catch {
            state = .failed(error.localizedDescription)
        }
    }

    func stop() {
        recorder?.stop()
        timer?.invalidate(); timer = nil
        try? AVAudioSession.sharedInstance().setActive(false)
        if state == .recording { state = .stopped }
    }
}
