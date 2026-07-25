import SwiftUI
import WidgetKit

@main
struct YapApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .onAppear(perform: publishToday)
                .onOpenURL { url in
                    guard url.scheme == "yap" else { return } // yap://today lands in the app
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
