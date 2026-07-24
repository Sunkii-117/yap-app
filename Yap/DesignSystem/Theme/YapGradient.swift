import SwiftUI

enum YapGradient {
    // radial spotlight — circle at 50% 40%
    static let spotlight = RadialGradient(
        stops: [
            .init(color: Color(hex: 0xA64BF4), location: 0.0),
            .init(color: Color(hex: 0x7C2BE0), location: 0.34),
            .init(color: Color(hex: 0x3B0F73), location: 0.72),
            .init(color: Color(hex: 0x180530), location: 1.0),
        ],
        center: UnitPoint(x: 0.5, y: 0.4), startRadius: 0, endRadius: 520
    )
    static let violet = LinearGradient(
        colors: [Color(hex: 0x8E2FE6), Color(hex: 0x5A1BB0)],
        startPoint: .top, endPoint: .bottom
    )
    static let foil = LinearGradient(
        stops: [
            .init(color: Color(hex: 0xFFE07A), location: 0.0),
            .init(color: Color(hex: 0xF6C324), location: 0.46),
            .init(color: Color(hex: 0xE8A317), location: 1.0),
        ],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )
}
