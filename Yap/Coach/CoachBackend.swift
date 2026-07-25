import Foundation

/// Where the filled coaching prompt is sent. The real implementation is an HTTP
/// call to the thin proxy that holds the Anthropic key (no key ships in the client).
/// Tests inject a mock returning fixture JSON.
protocol CoachBackend {
    func coach(prompt: String) async throws -> String
}
