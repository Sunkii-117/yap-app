import SwiftUI

/// Circular progress ring — the score dial and the record timer arc (design doc §4.3–4.4).
struct RingProgress<S: ShapeStyle>: View {
    var progress: Double
    var lineWidth: CGFloat = 12
    var track: Color = YapColor.studioRoyal
    var fill: S

    var body: some View {
        ZStack {
            Circle().stroke(track, lineWidth: lineWidth)
            Circle()
                .trim(from: 0, to: min(max(progress, 0), 1))
                .stroke(fill, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
    }
}

/// Read-only pill. `gold` = reward tint; otherwise neutral studio-royal (design doc §4.5).
struct YapChip: View {
    let text: String
    var gold: Bool = false

    var body: some View {
        Text(text)
            .font(YapType.caption)
            .foregroundStyle(gold ? YapColor.studioInk : YapColor.textSoft)
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(
                gold ? AnyShapeStyle(YapGradient.foil) : AnyShapeStyle(YapColor.studioRoyal),
                in: Capsule()
            )
    }
}

/// Tappable interest chip — gold when selected (design doc §7.1).
struct SelectableChip: View {
    let text: String
    let selected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(text)
                .font(YapType.body)
                .foregroundStyle(selected ? YapColor.studioInk : YapColor.textSoft)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .frame(minHeight: 44)
                .background(
                    selected ? AnyShapeStyle(YapGradient.foil) : AnyShapeStyle(YapColor.studioGrape),
                    in: Capsule()
                )
                .overlay(
                    Capsule().strokeBorder(
                        selected ? Color.clear : YapColor.studioLilac.opacity(0.3), lineWidth: 1
                    )
                )
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(selected ? [.isButton, .isSelected] : .isButton)
    }
}

/// Delta chip — ▲ mint (improved) / ▼ coral (dipped). The arrow carries the meaning
/// so it survives without color (design doc §1.5, §4.4).
struct DeltaChip: View {
    /// Negative fillers-delta reads as an improvement; the caller decides `improved`.
    let text: String
    let improved: Bool

    var body: some View {
        let color = improved ? YapColor.signalMint : YapColor.signalCoral
        return HStack(spacing: 4) {
            Image(systemName: improved ? "arrow.up.right" : "arrow.down.right")
                .font(.system(size: 12, weight: .heavy))
            Text(text).font(YapType.caption)
        }
        .foregroundStyle(color)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(color.opacity(0.15), in: Capsule())
    }
}

/// Streak flame — gold flame + Fraunces number (design doc §4.7).
struct StreakFlame: View {
    let count: Int

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "flame.fill")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(YapGradient.foil)
            Text("\(count)")
                .font(.custom(YapFontName.frauncesBlack, size: 22))
                .foregroundStyle(YapColor.foilGold)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(count) day streak")
    }
}

/// Uppercase gold/mute eyebrow label (design doc §2.2).
struct Eyebrow: View {
    let text: String
    var gold: Bool = true
    var body: some View {
        Text(text.uppercased())
            .font(YapType.eyebrow)
            .tracking(1.0)
            .foregroundStyle(gold ? YapColor.foilGold : YapColor.textMute)
    }
}
