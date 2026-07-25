import SwiftUI

/// "Coach is listening…" state shown while the recording is transcribed + scored
/// (design doc §4.3). On the spotlight so it feels continuous with the studio.
struct CoachingLoader: View {
    var body: some View {
        ZStack {
            YapGradient.spotlight.ignoresSafeArea()
            VStack(spacing: YapSpacing.s5) {
                YapbotOrb(size: 100)
                Text("Coach is listening…")
                    .font(YapType.subhead)
                    .foregroundStyle(YapColor.textWhite)
                ProgressView().tint(YapColor.foilGold)
            }
        }
    }
}
