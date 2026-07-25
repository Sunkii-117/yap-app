import XCTest
@testable import Yap

final class PromptProviderTests: XCTestCase {
    private var cal: Calendar {
        var c = Calendar(identifier: .gregorian)
        c.timeZone = TimeZone(identifier: "America/New_York")!
        return c
    }
    private func date(_ y: Int, _ m: Int, _ d: Int, _ h: Int = 12) -> Date {
        cal.date(from: DateComponents(year: y, month: m, day: d, hour: h))!
    }

    func test_stableWithinSameDay() {
        let p = PromptProvider(library: PromptLibrary.all)
        XCTAssertEqual(p.prompt(for: date(2026, 7, 25, 8), calendar: cal),
                       p.prompt(for: date(2026, 7, 25, 23), calendar: cal))
    }

    func test_advancesAcrossMidnight() {
        let p = PromptProvider(library: PromptLibrary.all)
        XCTAssertNotEqual(p.prompt(for: date(2026, 7, 25), calendar: cal).id,
                          p.prompt(for: date(2026, 7, 26), calendar: cal).id)
    }

    func test_wrapsAfterLibraryLength() {
        let lib = PromptLibrary.all
        let p = PromptProvider(library: lib)
        let day0 = date(2026, 7, 25)
        let dayN = cal.date(byAdding: .day, value: lib.count, to: day0)!
        XCTAssertEqual(p.prompt(for: day0, calendar: cal).id,
                       p.prompt(for: dayN, calendar: cal).id)
    }

    func test_libraryIsNonEmptyWithUniqueIDs() {
        XCTAssertGreaterThanOrEqual(PromptLibrary.all.count, 10)
        let ids = Set(PromptLibrary.all.map(\.id))
        XCTAssertEqual(ids.count, PromptLibrary.all.count, "prompt ids must be unique")
    }
}
