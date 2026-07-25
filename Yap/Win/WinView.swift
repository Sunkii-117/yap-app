import SwiftUI

/// A milestone worth celebrating (design doc §7.6). Milestones only, so it stays special.
enum WinKind: Equatable {
    case firstYap
    case streak(Int)

    var headline: String {
        switch self {
        case .firstYap:        return "You just yapped!"
        case .streak(let n):   return "\(n)-day streak!"
        }
    }
    var subtitle: String {
        switch self {
        case .firstYap:  return "That's the whole game — the first rep is the hardest, and you did it."
        case .streak:    return "Consistency is the flex. Keep the flame lit."
        }
    }
}

/// Full-spotlight celebration: Yapbot, a Fraunces headline, gold-foil confetti,
/// one gold CTA. Reduce Motion drops the confetti + entrance to a fade.
struct WinView: View {
    let kind: WinKind
    let onDone: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var appear = false

    var body: some View {
        ZStack {
            YapGradient.spotlight.ignoresSafeArea()
            if !reduceMotion { ConfettiView().ignoresSafeArea() }

            VStack(spacing: YapSpacing.s5) {
                Spacer()
                YapbotOrb(size: 132)
                    .scaleEffect((appear || reduceMotion) ? 1 : 0.8)
                Text(kind.headline)
                    .font(YapType.hero)
                    .foregroundStyle(YapColor.textWhite)
                    .multilineTextAlignment(.center)
                Text(kind.subtitle)
                    .font(YapType.bodyL)
                    .foregroundStyle(YapColor.textSoft)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, YapSpacing.s6)
                Spacer()
                Button("Keep going", action: onDone)
                    .buttonStyle(CandyButtonStyle(.gold))
                    .padding(.horizontal, YapSpacing.s6)
            }
            .padding(YapSpacing.s5)
        }
        .onAppear {
            guard !reduceMotion else { appear = true; return }
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) { appear = true }
        }
    }
}

#Preview { WinView(kind: .firstYap, onDone: {}) }
