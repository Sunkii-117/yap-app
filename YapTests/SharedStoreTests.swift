import XCTest
@testable import Yap

final class SharedStoreTests: XCTestCase {
    private func ephemeralStore() -> (SharedStore, UserDefaults) {
        let suite = "test.yap.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suite)!
        return (SharedStore(defaults: defaults), defaults)
    }

    func test_missingPrompt_isNil() {
        let (store, _) = ephemeralStore()
        XCTAssertNil(store.todayPrompt)
    }

    func test_roundTripsPrompt() {
        let (store, _) = ephemeralStore()
        let p = PromptLibrary.all[0]
        store.todayPrompt = p
        XCTAssertEqual(store.todayPrompt, p)
    }

    func test_overwriteReplaces() {
        let (store, _) = ephemeralStore()
        store.todayPrompt = PromptLibrary.all[0]
        store.todayPrompt = PromptLibrary.all[1]
        XCTAssertEqual(store.todayPrompt, PromptLibrary.all[1])
    }
}
