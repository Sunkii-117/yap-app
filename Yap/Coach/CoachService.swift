import Foundation

/// Orchestrates the coach: compute exact metrics in code, fill the prompt, call the
/// backend (proxy), parse + validate the LLM judgment, and assemble the result with a
/// deterministic delta vs the previous yap. The metrics never depend on the model.
struct CoachService {
    let backend: CoachBackend

    func coach(transcript: String, durationSec: Double, previous: CoachMetrics?) async throws -> CoachResult {
        let metrics = CoachMetrics.compute(transcript: transcript, durationSec: durationSec)
        let prev = previous.map { "wpm=\($0.wpm), fillers_total=\($0.fillersTotal)" } ?? "none (first yap)"
        let prompt = CoachPrompt.filled(transcript: transcript, metricsJSON: metrics.encodedJSON(), previous: prev)

        let raw = try await backend.coach(prompt: prompt)
        let coaching = try CoachingParser.parse(raw)

        return CoachResult(
            metrics: metrics,
            coaching: coaching,
            delta: MetricsDelta.between(current: metrics, previous: previous)
        )
    }
}
