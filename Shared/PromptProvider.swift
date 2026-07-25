import Foundation

/// Deterministically selects the "prompt of the day" from a library.
/// Stable within a local calendar day, advances at local midnight, wraps the list.
struct PromptProvider {
    let library: [Prompt]

    /// Fixed anchor so the day index is stable across launches and devices.
    private let referenceDate = Date(timeIntervalSince1970: 1_577_836_800) // 2020-01-01T00:00:00Z

    func prompt(for date: Date, calendar: Calendar = .current) -> Prompt {
        precondition(!library.isEmpty, "PromptLibrary must not be empty")
        let start = calendar.startOfDay(for: referenceDate)
        let today = calendar.startOfDay(for: date)
        let days = calendar.dateComponents([.day], from: start, to: today).day ?? 0
        let n = library.count
        let index = ((days % n) + n) % n // true modulo, safe for negative day spans
        return library[index]
    }
}
