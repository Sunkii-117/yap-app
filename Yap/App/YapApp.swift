import SwiftUI
import WidgetKit

@main
struct YapApp: App {
    @State private var auth = AuthController(service: AuthServiceFactory.make())

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(auth)
                .task { await auth.restore() }               // resume a persisted session
                .onAppear(perform: publishToday)
                .onOpenURL { url in
                    guard url.scheme == "yap" else { return } // yap://… lands in the app
                    if url.host == "auth-callback" {          // magic link / OAuth redirect
                        Task { await auth.handleCallback(url: url) }
                    }
                }
        }
        .modelContainer(for: YapRecord.self)
    }

    /// Keep the App Group + widget in sync with today's prompt.
    private func publishToday() {
        let prompt = PromptProvider(library: PromptLibrary.all).prompt(for: .now)
        SharedStore().todayPrompt = prompt
        WidgetCenter.shared.reloadAllTimelines()
    }
}
