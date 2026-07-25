import SwiftUI

/// First-run flow (design doc §7.1, reshaped 2026-07-25): normal onboarding —
/// warm welcome, pick a goal, pick interests — then into the app. No 15s gimmick.
struct OnboardingView: View {
    let onDone: () -> Void

    @AppStorage("yap.goal") private var goal = ""
    @AppStorage("yap.interests") private var interestsCSV = ""
    @State private var selected: Set<String> = []

    private let goals: [(id: String, label: String, icon: String)] = [
        ("post", "Start posting", "video.fill"),
        ("confident", "Get more confident", "bolt.heart.fill"),
        ("curious", "Just curious", "sparkles"),
    ]
    private let interests = [
        "Sports takes", "Work stories", "Pop culture", "Fitness", "Tech",
        "Food", "Money", "Relationships", "Gaming", "Music",
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: YapSpacing.s6) {
                YapbotOrb(size: 108).frame(maxWidth: .infinity).padding(.top, YapSpacing.s4)

                VStack(alignment: .leading, spacing: YapSpacing.s2) {
                    Text("Let's find your voice.")
                        .font(YapType.hero).foregroundStyle(YapColor.textWhite)
                    Text("A minute a day. Nobody sees this but you — until you decide to share.")
                        .font(YapType.bodyL).foregroundStyle(YapColor.textSoft)
                }

                VStack(alignment: .leading, spacing: YapSpacing.s3) {
                    Eyebrow(text: "What do you want out of Yap?")
                    ForEach(goals, id: \.id) { goalCard($0) }
                }

                VStack(alignment: .leading, spacing: YapSpacing.s3) {
                    Eyebrow(text: "Pick a few interests")
                    FlowLayout(spacing: 10) {
                        ForEach(interests, id: \.self) { name in
                            SelectableChip(text: name, selected: selected.contains(name)) {
                                if selected.contains(name) { selected.remove(name) } else { selected.insert(name) }
                            }
                        }
                    }
                }

                Button("Continue") {
                    interestsCSV = selected.sorted().joined(separator: ",")
                    onDone()
                }
                .buttonStyle(CandyButtonStyle(.gold))
                .disabled(goal.isEmpty)
                .opacity(goal.isEmpty ? 0.5 : 1)
                .padding(.top, YapSpacing.s4)
            }
            .padding(YapSpacing.s5)
        }
        .background(YapColor.studioInk.ignoresSafeArea())
    }

    private func goalCard(_ g: (id: String, label: String, icon: String)) -> some View {
        let isOn = goal == g.id
        return Button { goal = isOn ? "" : g.id } label: {
            HStack(spacing: YapSpacing.s3) {
                Image(systemName: g.icon)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(isOn ? YapColor.studioInk : YapColor.foilGold)
                    .frame(width: 28)
                Text(g.label)
                    .font(YapType.subhead)
                    .foregroundStyle(isOn ? YapColor.studioInk : YapColor.textWhite)
                Spacer()
                if isOn {
                    Image(systemName: "checkmark.circle.fill").foregroundStyle(YapColor.studioInk)
                }
            }
            .padding(YapSpacing.s4)
            .frame(maxWidth: .infinity, minHeight: 44)
            .background(
                isOn ? AnyShapeStyle(YapGradient.foil) : AnyShapeStyle(YapColor.studioGrape),
                in: RoundedRectangle(cornerRadius: YapRadius.lg)
            )
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isOn ? [.isButton, .isSelected] : .isButton)
    }
}

#Preview { OnboardingView(onDone: {}) }
