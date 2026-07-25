import Foundation

/// Deterministic yap metrics — the Swift twin of the S1 `coachmetrics` tool.
/// Filler counts and WPM are computed in code so they are exact and cheap; the
/// LLM never counts. Keep the filler lexicon in sync with the spike.
struct CoachMetrics: Codable, Equatable {
    let wordCount: Int
    let durationSec: Double
    let wpm: Int
    let fillers: [String: Int]
    let fillersTotal: Int

    /// Filler lexicon — the common verbal-filler set for English talking-to-camera.
    /// "so"/"right"/"well" as legit sentence words are excluded to protect the ±1
    /// accuracy target; only "right," (with a trailing comma) is treated as a filler.
    private static let lexicon = [
        "um", "uh", "er", "ah", "hmm",
        "like", "you know", "i mean", "actually", "basically",
        "literally", "kinda", "kind of", "sort of", "right,",
    ]

    static func compute(transcript: String, durationSec: Double) -> CoachMetrics {
        let lower = transcript.lowercased()
        let wordCount = regexCount("[\\p{L}']+", in: lower)

        var counts: [String: Int] = [:]
        for filler in lexicon {
            let escaped = NSRegularExpression.escapedPattern(for: filler)
            // Trailing-comma tokens (e.g. "right,") already carry their own edge.
            let pattern = filler.hasSuffix(",") ? escaped : "\\b\(escaped)\\b"
            let c = regexCount(pattern, in: lower)
            if c > 0 { counts[filler == "right," ? "right" : filler] = c }
        }

        let total = counts.values.reduce(0, +)
        let wpm = durationSec > 0
            ? Int((Double(wordCount) / (durationSec / 60.0)).rounded())
            : 0

        return CoachMetrics(
            wordCount: wordCount, durationSec: durationSec,
            wpm: wpm, fillers: counts, fillersTotal: total
        )
    }

    private static func regexCount(_ pattern: String, in text: String) -> Int {
        guard let re = try? NSRegularExpression(pattern: pattern) else { return 0 }
        return re.numberOfMatches(in: text, range: NSRange(text.startIndex..., in: text))
    }
}
