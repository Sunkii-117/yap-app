import SwiftUI

/// Placeholder Yapbot mascot — a violet orb with friendly eyes and a gold mic badge.
/// Design doc §4.10 specs a commissioned illustration; this is the on-brand slot for it.
struct YapbotOrb: View {
    var size: CGFloat = 120

    var body: some View {
        ZStack {
            Circle()
                .fill(YapGradient.violet)
                .overlay(Circle().strokeBorder(YapColor.studioOrchid.opacity(0.6), lineWidth: 2))
                .shadow(color: YapColor.studioOrchid.opacity(0.5), radius: 20, y: 8)

            HStack(spacing: size * 0.16) {
                eye
                eye
            }
            .offset(y: -size * 0.06)

            Image(systemName: "mic.fill")
                .font(.system(size: size * 0.2, weight: .bold))
                .foregroundStyle(YapColor.studioInk)
                .padding(size * 0.1)
                .background(YapGradient.foil, in: Circle())
                .offset(x: size * 0.3, y: size * 0.32)
        }
        .frame(width: size, height: size)
        .accessibilityHidden(true)
    }

    private var eye: some View {
        Capsule()
            .fill(YapColor.textWhite)
            .frame(width: size * 0.09, height: size * 0.17)
    }
}
