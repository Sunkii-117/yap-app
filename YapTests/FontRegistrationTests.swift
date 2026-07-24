import XCTest
import UIKit
@testable import Yap

final class FontRegistrationTests: XCTestCase {
    func test_frauncesFamilyRegistered() {
        XCTAssertTrue(UIFont.familyNames.contains("Fraunces"), "Fraunces not bundled/registered")
        let faces = UIFont.fontNames(forFamilyName: "Fraunces")
        XCTAssertGreaterThanOrEqual(faces.count, 3, "expected Black/Bold/SemiBold, got \(faces)")
    }
    func test_nunitoFamilyRegistered() {
        XCTAssertTrue(UIFont.familyNames.contains("Nunito"), "Nunito not bundled/registered")
        let faces = UIFont.fontNames(forFamilyName: "Nunito")
        XCTAssertGreaterThanOrEqual(faces.count, 2, "expected ExtraBold/SemiBold, got \(faces)")
    }
    func test_namedFacesResolve() {
        XCTAssertNotNil(UIFont(name: YapFontName.frauncesBlack, size: 88))
        XCTAssertNotNil(UIFont(name: YapFontName.nunitoExtraBold, size: 17))
    }
}
