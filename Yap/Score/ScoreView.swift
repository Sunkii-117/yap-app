import SwiftUI

/// Score & coaching reveal (design doc §7.5): count-up score in a gold ring, a
/// delta chip, filler chips, pace, ≤3 forward-looking tips, a gold highlight, and
/// the keep/post/send actions. Consumes a real `CoachResult`.
struct ScoreView: View {
    let result: CoachResult
    let onDone: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @AppStorage("yap.streak") private var streak = 0
    @AppStorage("yap.total") private var total = 0
    @State private var shownScore: Int = 0

    private var score: Int { result.coaching.score }
    private var canPost: Bool { score >= 75 }

    var body: some View {
        ZStack {
            YapColor.studioInk.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: YapSpacing.s6) {
                    dial
                    fillers
                    tips
                    highlight
                    actions
                }
                .padding(YapSpacing.s5)
            }
        }
        .onAppear(perform: countUp)
    }

    /// Eased 0→score count-up over ~0.9s; instant under Reduce Motion (design doc §4.4).
    private func countUp() {
        if reduceMotion { shownScore = score; return }
        Task { @MainActor in
            let start = Date(); let duration = 0.9
            while true {
                let t = min(1, Date().timeIntervalSince(start) / duration)
                let eased = 1 - pow(1 - t, 3)
                shownScore = Int((eased * Double(score)).rounded())
                if t >= 1 { break }
                try? await Task.sleep(nanoseconds: 16_000_000)
            }
            shownScore = score
        }
    }

    private var dial: some View {
        VStack(spacing: YapSpacing.s3) {
            ZStack {
                RingProgress(progress: Double(shownScore) / 100, lineWidth: 14,
                             track: YapColor.studioRoyal, fill: YapGradient.foil)
                    .frame(width: 180, height: 180)
                Text("\(shownScore)")
                    .font(.custom(YapFontName.frauncesBlack, size: 72))
                    .foregroundStyle(YapColor.textWhite)
                    .monospacedDigit()
            }
            if let delta = result.delta {
                let improved = delta.fillersDelta <= 0
                DeltaChip(text: deltaText(delta), improved: improved)
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var fillers: some View {
        VStack(alignment: .leading, spacing: YapSpacing.s3) {
            Eyebrow(text: "Fillers")
            FlowLayout(spacing: 8) {
                ForEach(result.metrics.fillers.sorted { $0.value > $1.value }, id: \.key) { key, count in
                    YapChip(text: "\(key) ×\(count)")
                }
            }
            Text("Pace \(result.metrics.wpm) wpm · \(Int(result.metrics.durationSec))s")
                .font(YapType.caption)
                .foregroundStyle(YapColor.textMute)
        }
    }

    private var tips: some View {
        VStack(alignment: .leading, spacing: YapSpacing.s3) {
            Eyebrow(text: "Try next time")
            ForEach(Array(result.coaching.tips.prefix(3).enumerated()), id: \.offset) { _, tip in
                YapCard {
                    HStack(alignment: .top, spacing: YapSpacing.s3) {
                        Image(systemName: "lightbulb.fill")
                            .foregroundStyle(YapColor.foilGold)
                            .padding(.top, 2)
                        Text(tip).font(YapType.bodyL).foregroundStyle(YapColor.textSoft)
                    }
                }
            }
        }
    }

    private var highlight: some View {
        HStack(alignment: .top, spacing: YapSpacing.s2) {
            Image(systemName: "sparkles").foregroundStyle(YapColor.foilGold)
            Text(result.coaching.highlight)
                .font(YapType.body)
                .foregroundStyle(YapColor.foilSun)
        }
    }

    private var actions: some View {
        VStack(spacing: YapSpacing.s3) {
            if canPost {
                Button(action: finish) { Label("This one's good — post it", systemImage: "arrow.up.forward") }
                    .buttonStyle(CandyButtonStyle(.gold))
            }
            HStack(spacing: YapSpacing.s3) {
                Button("Save private", action: finish).buttonStyle(CandyButtonStyle(.ghost))
                Button("Send", action: finish).buttonStyle(CandyButtonStyle(.ghost))
            }
        }
        .padding(.top, YapSpacing.s4)
    }

    private func deltaText(_ d: MetricsDelta) -> String {
        if d.fillersDelta < 0 { return "\(-d.fillersDelta) fewer fillers" }
        if d.fillersDelta == 0 { return "same fillers as last time" }
        return "\(d.fillersDelta) more fillers"
    }

    private func finish() {
        streak += 1
        total += 1
        onDone()
    }
}
