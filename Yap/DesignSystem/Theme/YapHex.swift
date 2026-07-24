import SwiftUI

enum YapHex {
    static func components(_ hex: UInt32) -> (r: Double, g: Double, b: Double) {
        (
            r: Double((hex >> 16) & 0xFF) / 255,
            g: Double((hex >> 8) & 0xFF) / 255,
            b: Double(hex & 0xFF) / 255
        )
    }
}

extension Color {
    init(hex: UInt32) {
        let c = YapHex.components(hex)
        self.init(.sRGB, red: c.r, green: c.g, blue: c.b, opacity: 1)
    }
}
