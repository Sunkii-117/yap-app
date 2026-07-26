import Foundation

/// Central runtime configuration. Values resolve from a `UserDefaults` dev override first,
/// then Info.plist (populated from build settings / a gitignored `Secrets.xcconfig`).
///
/// Nothing here is a *private* secret: the Supabase anon key is public by design — row-level
/// security protects data, not the key — and the proxy URL is just an address. The Anthropic
/// key and the Supabase JWT secret live only on the server (the proxy), never in the client.
enum YapConfig {
    /// Deployed coach proxy endpoint; `nil` until set. No key in the client — only the URL.
    static var proxyURL: URL? {
        guard let raw = string("yap.proxyURL", plist: "PROXY_URL"), !raw.isEmpty else { return nil }
        return URL(string: raw)
    }

    /// Supabase project URL + anon key, or `nil` until both are provided.
    static var supabase: SupabaseConfig? {
        guard
            let urlString = string("yap.supabaseURL", plist: "SUPABASE_URL"), !urlString.isEmpty,
            let url = URL(string: urlString),
            let anonKey = string("yap.supabaseAnonKey", plist: "SUPABASE_ANON_KEY"), !anonKey.isEmpty
        else { return nil }
        return SupabaseConfig(url: url, anonKey: anonKey)
    }

    /// The custom-scheme redirect Supabase sends the magic link / OAuth result back to.
    /// Must match the redirect URL configured in the Supabase dashboard.
    static let authCallbackURL = URL(string: "yap://auth-callback")!

    /// Dev override (`UserDefaults`) → build config (Info.plist).
    private static func string(_ defaultsKey: String, plist plistKey: String) -> String? {
        if let dev = UserDefaults.standard.string(forKey: defaultsKey), !dev.isEmpty { return dev }
        return Bundle.main.object(forInfoDictionaryKey: plistKey) as? String
    }
}

struct SupabaseConfig: Sendable, Equatable {
    let url: URL
    let anonKey: String
}
