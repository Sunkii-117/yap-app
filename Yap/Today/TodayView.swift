import SwiftUI

/// Minimal functional landing screen — the widget's deep-link target.
/// Visual design is deferred (founder direction 2026-07-25); this reuses M0
/// components so it's on-brand without new design work. The record flow (M1)
/// will replace the disabled "Yap it" action.
struct TodayView: View {
    private let prompt = PromptProvider(library: PromptLibrary.all).prompt(for: .now)

    var body: some View {
        VStack(alignment: .leading, spacing: YapSpacing.s5) {
            Text("Today's yap")
                .font(YapType.subhead)
                .foregroundStyle(YapColor.foilGold)

            Text(prompt.text)
                .font(YapType.hero)
                .foregroundStyle(YapColor.textWhite)

            Text("~\(prompt.targetDurationSec)s · \(prompt.skill)")
                .font(YapType.caption)
                .foregroundStyle(YapColor.textMute)

            Spacer()

            Button("Yap it") {}
                .buttonStyle(CandyButtonStyle(.gold))
                .disabled(true) // record flow arrives in M1
        }
        .padding(YapSpacing.s6)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(YapColor.studioInk.ignoresSafeArea())
    }
}

#Preview { TodayView() }
