import XCTest
@testable import Yap

final class YapHexTests: XCTestCase {
    func test_components_splitsChannels() {
        let c = YapHex.components(0x180530)
        XCTAssertEqual(c.r, 24.0/255, accuracy: 0.0001)
        XCTAssertEqual(c.g, 5.0/255, accuracy: 0.0001)
        XCTAssertEqual(c.b, 48.0/255, accuracy: 0.0001)
    }
}
