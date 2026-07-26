import Foundation

/// Real `CoachBackend` — posts the filled prompt to the thin proxy, which holds the
/// Anthropic key and calls Claude. **No API key ships in the client** (only the proxy URL).
struct HTTPCoachBackend: CoachBackend {
    let endpoint: URL
    var session: URLSession = .shared
    /// Supabase access token for the signed-in user; attached as `Authorization: Bearer …`
    /// so the proxy can verify the caller before relaying to Claude. `nil` → no header.
    var accessToken: String? = nil

    private struct RequestBody: Encodable { let prompt: String }
    private struct ResponseBody: Decodable { let coaching: String }

    enum BackendError: Error, Equatable { case badStatus(Int) }

    func coach(prompt: String) async throws -> String {
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let accessToken, !accessToken.isEmpty {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        request.httpBody = try JSONEncoder().encode(RequestBody(prompt: prompt))

        let (data, response) = try await session.data(for: request)
        let status = (response as? HTTPURLResponse)?.statusCode ?? -1
        guard (200..<300).contains(status) else { throw BackendError.badStatus(status) }
        return try JSONDecoder().decode(ResponseBody.self, from: data).coaching
    }
}
