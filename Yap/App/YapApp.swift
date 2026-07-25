import SwiftUI
import WidgetKit

@main
struct YapApp: App {
    var body: some Scene {
        WindowGroup {
            TodayView()
                .onAppear(perform: publishToday)
                .onOpenURL { url in
                    // yap://today — Today is the root, so the deep link just lands here.
                    guard url.scheme == "yap" else { return }
                }
        }
    }

    /// Keep the App Group + widget in sync with today's prompt.
    private func publishToday() {
        let prompt = PromptProvider(library: PromptLibrary.all).prompt(for: .now)
        SharedStore().todayPrompt = prompt
        WidgetCenter.shared.reloadAllTimelines()
    }
}
