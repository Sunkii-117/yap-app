import Foundation

enum CoachingError: Error, Equatable {
    case notJSON
    case invalidShape(String)
}

/// Parses the LLM's coaching JSON. Tolerates ```json fences / surrounding prose by
/// extracting the outermost `{ ... }`, then decodes and validates the contract.
/// This is the malformed-output guard (M3 DoD): anything off-contract throws so the
/// service can surface a calm, retryable state instead of showing garbage.
enum CoachingParser {
    static func parse(_ raw: String) throws -> CoachCoaching {
        let json = try extractJSONObject(raw)
        let coaching: CoachCoaching
        do {
            coaching = try JSONDecoder().decode(CoachCoaching.self, from: Data(json.utf8))
        } catch {
            throw CoachingError.invalidShape("decode failed: \(error)")
        }
        try validate(coaching)
        return coaching
    }

    private static func extractJSONObject(_ raw: String) throws -> String {
        guard let start = raw.firstIndex(of: "{"),
              let end = raw.lastIndex(of: "}"),
              start < end else {
            throw CoachingError.notJSON
        }
        return String(raw[start...end])
    }

    private static func validate(_ c: CoachCoaching) throws {
        guard (0...100).contains(c.score) else {
            throw CoachingError.invalidShape("score out of range: \(c.score)")
        }
        guard (2...3).contains(c.tips.count) else {
            throw CoachingError.invalidShape("tips must be 2–3, got \(c.tips.count)")
        }
        let blank = { (s: String) in s.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        guard !blank(c.highlight) else { throw CoachingError.invalidShape("empty highlight") }
        guard !c.tips.contains(where: blank) else { throw CoachingError.invalidShape("empty tip") }
    }
}
