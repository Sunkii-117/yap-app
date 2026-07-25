import Foundation

/// Deterministic movement vs the previous yap. Signs are preserved so the UI can
/// color them (▼ mint = fewer fillers is better; the UI decides good/bad direction).
/// `between` returns nil when there is no previous yap (first-ever scored yap).
struct MetricsDelta: Codable, Equatable {
    let fillersDelta: Int   // current.fillersTotal - previous.fillersTotal
    let wpmDelta: Int       // current.wpm - previous.wpm

    static func between(current: CoachMetrics, previous: CoachMetrics?) -> MetricsDelta? {
        guard let previous else { return nil }
        return MetricsDelta(
            fillersDelta: current.fillersTotal - previous.fillersTotal,
            wpmDelta: current.wpm - previous.wpm
        )
    }
}
