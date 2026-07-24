import SwiftUI

struct DesignSystemGallery: View {
    private let swatches: [(String, Color)] = [
        ("studio-ink", YapColor.studioInk), ("studio-grape", YapColor.studioGrape),
        ("studio-royal", YapColor.studioRoyal), ("studio-violet", YapColor.studioViolet),
        ("studio-orchid", YapColor.studioOrchid), ("studio-lilac", YapColor.studioLilac),
        ("foil-amber", YapColor.foilAmber), ("foil-gold", YapColor.foilGold),
        ("foil-sun", YapColor.foilSun), ("foil-glow", YapColor.foilGlow),
    ]
    private let cols = [GridItem(.adaptive(minimum: 90), spacing: 12)]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: YapSpacing.s7) {
                Text("Yap").font(YapType.hero).foregroundStyle(YapColor.textWhite)
                Text("Design System").font(YapType.subhead).foregroundStyle(YapColor.foilGold)

                LazyVGrid(columns: cols, spacing: 12) {
                    ForEach(swatches, id: \.0) { name, color in
                        VStack(spacing: 6) {
                            RoundedRectangle(cornerRadius: YapRadius.md).fill(color).frame(height: 56)
                            Text(name).font(YapType.caption).foregroundStyle(YapColor.textMute)
                        }
                    }
                }

                YapCard {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("What's a hill you'll die on?").font(YapType.title).foregroundStyle(YapColor.textWhite)
                        Text("~60s · Spicy").font(YapType.caption).foregroundStyle(YapColor.textMute)
                    }
                }

                VStack(spacing: 16) {
                    Button("Record") {}.buttonStyle(CandyButtonStyle(.gold))
                    Button("Help me script") {}.buttonStyle(CandyButtonStyle(.violet))
                    Button("Save private") {}.buttonStyle(CandyButtonStyle(.ghost))
                }
            }
            .padding(YapSpacing.s5)
        }
        .background(YapColor.studioInk.ignoresSafeArea())
    }
}

#Preview { DesignSystemGallery() }
