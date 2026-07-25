import SwiftUI

/// Home (design doc §7.2): streak, today's prompt card, "Yap it" / "Help me script",
/// a mini week strip. The prompt comes from the same `PromptProvider` the widget uses.
struct TodayView: View {
    var onYap: () -> Void = {}

    @AppStorage("yap.streak") private var streak = 0
    private let prompt = PromptProvider(library: PromptLibrary.all).prompt(for: .now)

    var body: some View {
        ZStack {
            YapColor.studioInk.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: YapSpacing.s6) {
                    HStack {
                        StreakFlame(count: streak)
                        Spacer()
                        Image(systemName: "sparkles")
                            .foregroundStyle(YapColor.foilGold)
                            .accessibilityLabel("Yap Pro")
                    }

                    VStack(alignment: .leading, spacing: YapSpacing.s3) {
                        Eyebrow(text: "Today's yap")
                        YapCard {
                            VStack(alignment: .leading, spacing: YapSpacing.s3) {
                                Text(prompt.text)
                                    .font(YapType.title)
                                    .foregroundStyle(YapColor.textWhite)
                                HStack(spacing: YapSpacing.s2) {
                                    YapChip(text: "~\(prompt.targetDurationSec)s")
                                    YapChip(text: prompt.skill)
                                }
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: YapSpacing.s3) {
                        Eyebrow(text: "Your week", gold: false)
                        HStack(spacing: 10) {
                            ForEach(0..<7, id: \.self) { i in
                                Circle()
                                    .fill(i < streak
                                          ? AnyShapeStyle(YapGradient.foil)
                                          : AnyShapeStyle(YapColor.studioRoyal))
                                    .frame(width: 20, height: 20)
                            }
                        }
                    }

                    Spacer(minLength: YapSpacing.s8)

                    VStack(spacing: YapSpacing.s3) {
                        Button(action: onYap) {
                            Label("Yap it", systemImage: "mic.fill")
                        }
                        .buttonStyle(CandyButtonStyle(.gold))

                        Button("Help me script") {}
                            .buttonStyle(CandyButtonStyle(.ghost))
                            .disabled(true) // Yapbot scripting is M5
                    }
                }
                .padding(YapSpacing.s5)
            }
        }
    }
}

#Preview { TodayView() }
