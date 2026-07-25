import Foundation

/// The LLM judgment layer — shape from the spike `prompt.md`. Decoded from the proxy.
struct CoachCoaching: Codable, Equatable {
    let score: Int          // 0–100, "how did this land" — momentum, not a school grade
    let deltaNote: String   // one sentence vs last time
    let tips: [String]      // 2–3 forward-looking nudges tied to this transcript
    let highlight: String   // the single line that landed best

    enum CodingKeys: String, CodingKey {
        case score
        case deltaNote = "delta_note"
        case tips
        case highlight
    }
}

/// The full coach output the app consumes: exact metrics + LLM judgment + deterministic delta.
struct CoachResult: Codable, Equatable {
    let metrics: CoachMetrics
    let coaching: CoachCoaching
    let delta: MetricsDelta?   // nil for the first-ever scored yap
}
