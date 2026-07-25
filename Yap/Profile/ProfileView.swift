import SwiftUI

/// Private profile (design doc §7.7), simple first pass: streak + total as big gold
/// Fraunces numbers, a few skill-trend rows. Sparklines/highlight reel are later.
struct ProfileView: View {
    @AppStorage("yap.streak") private var streak = 0
    @AppStorage("yap.total") private var total = 0

    var body: some View {
        ZStack {
            YapColor.studioInk.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: YapSpacing.s6) {
                    Text("You").font(YapType.hero).foregroundStyle(YapColor.textWhite)

                    HStack(spacing: YapSpacing.s4) {
                        statTile(title: "Day streak", value: "\(streak)")
                        statTile(title: "Total yaps", value: "\(total)")
                    }

                    VStack(alignment: .leading, spacing: YapSpacing.s3) {
                        Eyebrow(text: "Skill trend")
                        trendRow(icon: "waveform", label: "Fillers", note: "fewer over time", improved: true)
                        trendRow(icon: "gauge.medium", label: "Pace", note: "in the sweet spot", improved: true)
                        trendRow(icon: "text.aligncenter", label: "Clarity", note: "climbing", improved: true)
                    }
                    Spacer()
                }
                .padding(YapSpacing.s5)
            }
        }
    }

    private func statTile(title: String, value: String) -> some View {
        YapCard {
            VStack(alignment: .leading, spacing: YapSpacing.s1) {
                Text(value)
                    .font(.custom(YapFontName.frauncesBlack, size: 44))
                    .foregroundStyle(YapColor.foilGold)
                Text(title).font(YapType.caption).foregroundStyle(YapColor.textMute)
            }
        }
    }

    private func trendRow(icon: String, label: String, note: String, improved: Bool) -> some View {
        YapCard {
            HStack(spacing: YapSpacing.s3) {
                Image(systemName: icon).foregroundStyle(YapColor.studioOrchid).frame(width: 28)
                Text(label).font(YapType.subhead).foregroundStyle(YapColor.textWhite)
                Spacer()
                DeltaChip(text: note, improved: improved)
            }
        }
    }
}

#Preview { ProfileView() }
