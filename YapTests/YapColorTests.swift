import XCTest
@testable import Yap

final class YapColorTests: XCTestCase {
    // Values copied verbatim from tokens.json — this test IS the guard that code matches the doc.
    func test_tokenHexesMatchDesignDoc() {
        XCTAssertEqual(YapColor.hex["studio-ink"],    0x180530)
        XCTAssertEqual(YapColor.hex["studio-grape"],  0x2C0A56)
        XCTAssertEqual(YapColor.hex["studio-royal"],  0x4A159C)
        XCTAssertEqual(YapColor.hex["studio-violet"], 0x7C2BE0)
        XCTAssertEqual(YapColor.hex["studio-orchid"], 0xA64BF4)
        XCTAssertEqual(YapColor.hex["studio-lilac"],  0xC9A6F0)
        XCTAssertEqual(YapColor.hex["foil-amber"],    0xE8A317)
        XCTAssertEqual(YapColor.hex["foil-gold"],     0xF6C324)
        XCTAssertEqual(YapColor.hex["foil-sun"],      0xFFE07A)
        XCTAssertEqual(YapColor.hex["foil-glow"],     0xFFF1A8)
        XCTAssertEqual(YapColor.hex["text-white"],    0xFFFFFF)
        XCTAssertEqual(YapColor.hex["text-soft"],     0xF1E9FF)
        XCTAssertEqual(YapColor.hex["text-mute"],     0xB79ED6)
        XCTAssertEqual(YapColor.hex["signal-coral"],  0xFF5C7A)
        XCTAssertEqual(YapColor.hex["signal-mint"],   0x3CE0B0)
        XCTAssertEqual(YapColor.hex.count, 15)
    }
}
