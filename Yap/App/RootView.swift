import SwiftUI
import SwiftData

/// Routes first-run onboarding vs the main app. Dark-only at launch (design doc §12).
struct RootView: View {
    @AppStorage("yap.onboarded") private var onboarded = false
    @Environment(AuthController.self) private var auth

    var body: some View {
        Group {
            #if DEBUG
            if let screen = UserDefaults.standard.string(forKey: "yapScreen") {
                DebugScreen(name: screen)
            } else {
                main
            }
            #else
            main
            #endif
        }
        .preferredColorScheme(.dark)
    }

    /// Auth first, then onboarding, then the app. Unauthenticated users can't reach the loop.
    @ViewBuilder private var main: some View {
        if !auth.isSignedIn {
            AuthGate(auth: auth)
        } else if onboarded {
            MainTabView()
        } else {
            OnboardingView(onDone: { withAnimation { onboarded = true } })
        }
    }
}

/// The 5-tab shell (design doc §4.9): Today, Coach, a raised center Record FAB,
/// Friends, Profile. Coach/Friends are placeholders (M5 / V1.5). The FAB opens the
/// Record→Coach→Score→Win flow full-screen.
struct MainTabView: View {
    @State private var tab: Tab = .today
    @State private var showRecord = false

    enum Tab: Hashable { case today, coach, friends, profile }

    var body: some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(YapColor.studioInk.ignoresSafeArea())
            .safeAreaInset(edge: .bottom, spacing: 0) {
                YapTabBar(selection: $tab, onRecord: { showRecord = true })
            }
            .fullScreenCover(isPresented: $showRecord) {
                RecordFlow(onFinish: { showRecord = false })
            }
    }

    @ViewBuilder private var content: some View {
        switch tab {
        case .today:   TodayView(onYap: { showRecord = true })
        case .coach:   ComingSoon(icon: "bubble.left.and.bubble.right.fill", title: "Yapbot",
                                  subtitle: "Your scripting coach lands in M5.")
        case .friends: ComingSoon(icon: "person.2.fill", title: "Dojo",
                                  subtitle: "The friends feed is V1.5 — everyone's leveling up.")
        case .profile: ProfileView()
        }
    }
}

/// Custom bottom bar with the raised gold Record FAB.
struct YapTabBar: View {
    @Binding var selection: MainTabView.Tab
    let onRecord: () -> Void

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            tab(.today, icon: "house.fill", label: "Today")
            tab(.coach, icon: "bubble.left.and.bubble.right.fill", label: "Coach")
            recordFAB
            tab(.friends, icon: "person.2.fill", label: "Friends")
            tab(.profile, icon: "person.fill", label: "Profile")
        }
        .padding(.horizontal, 8)
        .padding(.top, 12)
        .padding(.bottom, 4)
        .background(
            YapColor.studioGrape
                .overlay(alignment: .top) {
                    Rectangle().fill(YapColor.studioLilac.opacity(0.12)).frame(height: 1)
                }
                .ignoresSafeArea(edges: .bottom)
        )
    }

    private var recordFAB: some View {
        Button(action: onRecord) {
            Image(systemName: "mic.fill")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(YapColor.studioInk)
                .frame(width: 60, height: 60)
                .background(YapGradient.foil, in: Circle())
                .yapShadow(YapShadow.glowGold)
        }
        .frame(maxWidth: .infinity)
        .offset(y: -16)
        .accessibilityLabel("Record")
    }

    private func tab(_ t: MainTabView.Tab, icon: String, label: String) -> some View {
        Button { selection = t } label: {
            VStack(spacing: 3) {
                Image(systemName: icon).font(.system(size: 20, weight: .semibold))
                Text(label).font(.system(size: 10, weight: .bold))
            }
            .foregroundStyle(selection == t ? YapColor.studioOrchid : YapColor.studioLilac)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(selection == t ? [.isButton, .isSelected] : .isButton)
    }
}

/// Placeholder for not-yet-built tabs.
struct ComingSoon: View {
    let icon: String
    let title: String
    let subtitle: String
    var body: some View {
        ZStack {
            YapColor.studioInk.ignoresSafeArea()
            VStack(spacing: YapSpacing.s4) {
                Image(systemName: icon)
                    .font(.system(size: 44, weight: .bold))
                    .foregroundStyle(YapColor.studioOrchid)
                Text(title).font(YapType.hero).foregroundStyle(YapColor.textWhite)
                Text(subtitle).font(YapType.bodyL).foregroundStyle(YapColor.textMute)
                    .multilineTextAlignment(.center)
            }
            .padding(YapSpacing.s6)
        }
    }
}

/// Record → (coach) → Score → (win). Persists a `YapRecord` on finish and celebrates
/// milestones (first yap, 7-day streak marks). The coach isn't live until the proxy
/// is deployed; `CoachRunner` handles the fallback so the loop still completes.
struct RecordFlow: View {
    let onFinish: () -> Void

    @Environment(\.modelContext) private var context
    @AppStorage("yap.streak") private var streak = 0
    @State private var phase: Phase = .recording
    @State private var pendingURL: URL?

    private enum Phase { case recording, coaching, score(CoachResult), win(WinKind) }

    var body: some View {
        switch phase {
        case .recording:
            RecordView(
                onStop: { url, duration in
                    pendingURL = url
                    phase = .coaching
                    Task { await runCoach(url: url, duration: duration) }
                },
                onCancel: onFinish
            )
        case .coaching:
            CoachingLoader()
        case .score(let result):
            ScoreView(result: result, onDone: { finish(result) })
        case .win(let kind):
            WinView(kind: kind, onDone: onFinish)
        }
    }

    private func runCoach(url: URL?, duration: Double) async {
        let result = await CoachRunner.run(audioURL: url, durationSec: duration, previous: lastMetrics())
        withAnimation(.easeOut(duration: 0.25)) { phase = .score(result) }
    }

    private func finish(_ result: CoachResult) {
        persist(result)
        streak += 1
        let count = yapCount()
        if count == 1 {
            phase = .win(.firstYap)
        } else if streak > 0 && streak % 7 == 0 {
            phase = .win(.streak(streak))
        } else {
            onFinish()
        }
    }

    private func persist(_ result: CoachResult) {
        let prompt = PromptProvider(library: PromptLibrary.all).prompt(for: .now)
        let record = YapRecord(
            promptId: prompt.id,
            promptText: prompt.text,
            durationSec: result.metrics.durationSec,
            transcript: "",
            audioFileName: pendingURL?.lastPathComponent,
            score: result.coaching.score,
            fillersTotal: result.metrics.fillersTotal,
            wpm: result.metrics.wpm
        )
        context.insert(record)
        try? context.save()
    }

    private func lastMetrics() -> CoachMetrics? {
        var descriptor = FetchDescriptor<YapRecord>(sortBy: [SortDescriptor(\.createdAt, order: .reverse)])
        descriptor.fetchLimit = 1
        guard let last = try? context.fetch(descriptor).first else { return nil }
        return CoachMetrics(wordCount: 0, durationSec: last.durationSec, wpm: last.wpm,
                            fillers: [:], fillersTotal: last.fillersTotal)
    }

    private func yapCount() -> Int {
        (try? context.fetchCount(FetchDescriptor<YapRecord>())) ?? 0
    }
}

#if DEBUG
/// Renders one screen directly for screenshots/dev via `-yapScreen <name>`. Never ships.
struct DebugScreen: View {
    let name: String
    var body: some View {
        switch name {
        case "auth":       AuthGate(auth: AuthController(service: UnconfiguredAuthService()))
        case "onboarding": OnboardingView(onDone: {})
        case "tabs":       MainTabView()
        case "record":     RecordView(onStop: { _, _ in }, onCancel: {})
        case "score":      ScoreView(result: DemoCoachResult.make(), onDone: {})
        case "win":        WinView(kind: .firstYap, onDone: {})
        case "profile":    ProfileView()
        default:           TodayView()
        }
    }
}
#endif
