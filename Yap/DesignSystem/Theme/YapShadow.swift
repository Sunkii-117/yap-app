import SwiftUI

struct YapShadowStyle { let color: Color; let radius: CGFloat; let x: CGFloat; let y: CGFloat }

enum YapShadow {
    // --shadow-card: 0 8px 24px rgba(24,5,48,.45)
    static let card = YapShadowStyle(color: Color(hex: 0x180530).opacity(0.45), radius: 12, x: 0, y: 8)
    // --glow-gold: 0 8px 20px rgba(246,195,36,.35)
    static let glowGold = YapShadowStyle(color: Color(hex: 0xF6C324).opacity(0.35), radius: 10, x: 0, y: 8)
    // --glow-focus: 0 0 0 4px rgba(166,75,244,.45) — a ring, applied as a stroke overlay, not a blur
    static let focusRing = Color(hex: 0xA64BF4).opacity(0.45)
}

extension View {
    func yapShadow(_ s: YapShadowStyle) -> some View {
        shadow(color: s.color, radius: s.radius, x: s.x, y: s.y)
    }
}
