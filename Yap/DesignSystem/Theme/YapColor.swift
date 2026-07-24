import SwiftUI

enum YapColor {
    static let hex: [String: UInt32] = [
        "studio-ink": 0x180530, "studio-grape": 0x2C0A56, "studio-royal": 0x4A159C,
        "studio-violet": 0x7C2BE0, "studio-orchid": 0xA64BF4, "studio-lilac": 0xC9A6F0,
        "foil-amber": 0xE8A317, "foil-gold": 0xF6C324, "foil-sun": 0xFFE07A, "foil-glow": 0xFFF1A8,
        "text-white": 0xFFFFFF, "text-soft": 0xF1E9FF, "text-mute": 0xB79ED6,
        "signal-coral": 0xFF5C7A, "signal-mint": 0x3CE0B0,
    ]

    static let studioInk    = Color(hex: 0x180530)
    static let studioGrape  = Color(hex: 0x2C0A56)
    static let studioRoyal  = Color(hex: 0x4A159C)
    static let studioViolet = Color(hex: 0x7C2BE0)
    static let studioOrchid = Color(hex: 0xA64BF4)
    static let studioLilac  = Color(hex: 0xC9A6F0)
    static let foilAmber    = Color(hex: 0xE8A317)
    static let foilGold     = Color(hex: 0xF6C324)
    static let foilSun      = Color(hex: 0xFFE07A)
    static let foilGlow     = Color(hex: 0xFFF1A8)
    static let textWhite    = Color(hex: 0xFFFFFF)
    static let textSoft     = Color(hex: 0xF1E9FF)
    static let textMute     = Color(hex: 0xB79ED6)
    static let signalCoral  = Color(hex: 0xFF5C7A)
    static let signalMint   = Color(hex: 0x3CE0B0)
}
