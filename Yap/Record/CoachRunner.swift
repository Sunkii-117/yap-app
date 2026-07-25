import Foundation

/// Turns a finished recording into a `CoachResult`: on-device transcription → exact
/// metrics → live coach if a proxy is configured, else a metric-derived placeholder.
/// If the recording yields no usable transcript (e.g. a simulator with no mic), it
/// falls back to the demo sample so the Score screen still reads correctly.
@MainActor
enum CoachRunner {
    static func run(audioURL: URL?, durationSec: Double, previous: CoachMetrics?) async -> CoachResult {
        var transcript = ""
        if let audioURL {
            transcript = (try? await SpeechTranscriber().transcribe(audioURL: audioURL))?.text ?? ""
        }
        transcript = transcript.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !transcript.isEmpty else {
            return DemoCoachResult.make() // no usable audio → canned sample
        }

        let duration = durationSec > 0 ? durationSec : 60
        let metrics = CoachMetrics.compute(transcript: transcript, durationSec: duration)

        // Live coach, only when a proxy URL is set (after you deploy the proxy).
        if let endpoint = proxyEndpoint() {
            let service = CoachService(backend: HTTPCoachBackend(endpoint: endpoint))
            if let result = try? await service.coach(transcript: transcript, durationSec: duration, previous: previous) {
                return result
            }
        }

        // Placeholder coaching from the real metrics until the coach is connected.
        return CoachResult(
            metrics: metrics,
            coaching: placeholderCoaching(metrics),
            delta: MetricsDelta.between(current: metrics, previous: previous)
        )
    }

    /// Deployed proxy endpoint; empty until you set `yap.proxyURL`. No key in the client.
    static func proxyEndpoint() -> URL? {
        let raw = UserDefaults.standard.string(forKey: "yap.proxyURL") ?? ""
        return raw.isEmpty ? nil : URL(string: raw)
    }

    private static func placeholderCoaching(_ m: CoachMetrics) -> CoachCoaching {
        var tips: [String] = []
        if let top = m.fillers.max(by: { $0.value < $1.value }) {
            tips.append("Ease off \u{201C}\(top.key)\u{201D} — it showed up \(top.value) time\(top.value == 1 ? "" : "s").")
        }
        if m.wpm > 165 {
            tips.append("Slow down a touch — you were at \(m.wpm) wpm; a calmer ~140 lands better.")
        } else if m.wpm > 0 && m.wpm < 120 {
            tips.append("Bring a little more energy — \(m.wpm) wpm reads slow.")
        } else {
            tips.append("Your pace (\(m.wpm) wpm) sat in an easy-to-follow range.")
        }
        tips.append("Connect the coach for specific, line-by-line tips on your next yap.")

        return CoachCoaching(
            score: heuristicScore(m),
            deltaNote: "Metrics are exact; full coaching unlocks when the coach is connected.",
            tips: Array(tips.prefix(3)),
            highlight: "You finished the rep — that's the whole game. Keep them coming."
        )
    }

    private static func heuristicScore(_ m: CoachMetrics) -> Int {
        guard m.wordCount > 0 else { return 60 }
        let fillerRate = Double(m.fillersTotal) / Double(m.wordCount)
        let paceOff = abs(Double(m.wpm) - 145) / 145
        let raw = 100 - fillerRate * 180 - paceOff * 25
        return max(40, min(95, Int(raw.rounded())))
    }
}
