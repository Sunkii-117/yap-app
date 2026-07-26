import XCTest
@testable import Yap

final class YapConfigTests: XCTestCase {
    private let keys = ["yap.proxyURL", "yap.supabaseURL", "yap.supabaseAnonKey"]

    override func setUp() { keys.forEach { UserDefaults.standard.removeObject(forKey: $0) } }
    override func tearDown() { keys.forEach { UserDefaults.standard.removeObject(forKey: $0) } }

    func test_proxyURL_nilWhenUnset() {
        XCTAssertNil(YapConfig.proxyURL)
    }

    func test_proxyURL_fromDevOverride() {
        UserDefaults.standard.set("https://proxy.test/coach", forKey: "yap.proxyURL")
        XCTAssertEqual(YapConfig.proxyURL?.absoluteString, "https://proxy.test/coach")
    }

    func test_supabase_nilUntilBothPresent() {
        XCTAssertNil(YapConfig.supabase)
        UserDefaults.standard.set("https://abc.supabase.co", forKey: "yap.supabaseURL")
        XCTAssertNil(YapConfig.supabase, "URL alone isn't enough — needs the anon key")

        UserDefaults.standard.set("anon-key-xyz", forKey: "yap.supabaseAnonKey")
        let cfg = YapConfig.supabase
        XCTAssertEqual(cfg?.url.absoluteString, "https://abc.supabase.co")
        XCTAssertEqual(cfg?.anonKey, "anon-key-xyz")
    }

    func test_authCallbackURL_matchesScheme() {
        XCTAssertEqual(YapConfig.authCallbackURL.absoluteString, "yap://auth-callback")
    }
}
