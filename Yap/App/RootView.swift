import SwiftUI

/// Routes first-run onboarding vs the main app. Dark-only at launch (design doc §12).
struct RootView: View {
    @AppStorage("yap.onboarded") private var onboarded = false

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

    @ViewBuilder private var main: some View {
        if onboarded {
            MainTabView()
        } else {
            OnboardingView(onDone: { withAnimation { onboarded = true } })
        }
    }
}

#if DEBUG
/// Renders a single screen directly for screenshot/dev, selected by the launch arg
/// `-yapScreen <name>`. Never compiled into release builds.
struct DebugScreen: View {
    let name: String
    var body: some View {
        switch name {
        case "onboarding": OnboardingView(onDone: {})
        case "record":     RecordView(onStop: {}, onCancel: {})
        case "score":      ScoreView(result: DemoCoachResult.make(), onDone: {})
        case "profile":    ProfileView()
        default:           TodayView()
        }
    }
}
#endif

/// Simple tab shell: Today + Profile, with the Record→Score loop presented full-screen
/// from Today's "Yap it". (The full 5-tab bar with a center Record FAB is a later polish.)
struct MainTabView: View {
    @State private var showRecord = false

    var body: some View {
        TabView {
            TodayView(onYap: { showRecord = true })
                .tabItem { Label("Today", systemImage: "house.fill") }
            ProfileView()
                .tabItem { Label("Profile", systemImage: "person.fill") }
        }
        .tint(YapColor.studioOrchid)
        .fullScreenCover(isPresented: $showRecord) {
            RecordFlow(onFinish: { showRecord = false })
        }
    }
}

/// Record → Score, presented as one flow. The coach isn't live (no billing), so
/// stopping hands the score screen a sample `CoachResult`.
struct RecordFlow: View {
    let onFinish: () -> Void
    @State private var result: CoachResult?

    var body: some View {
        ZStack {
            if let result {
                ScoreView(result: result, onDone: onFinish)
            } else {
                RecordView(
                    onStop: { withAnimation(.easeOut(duration: 0.25)) { result = DemoCoachResult.make() } },
                    onCancel: onFinish
                )
            }
        }
    }
}
