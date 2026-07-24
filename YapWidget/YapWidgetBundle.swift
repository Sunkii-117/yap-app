import WidgetKit
import SwiftUI

struct TodayEntry: TimelineEntry { let date: Date; let prompt: String }

struct TodayProvider: TimelineProvider {
    func placeholder(in context: Context) -> TodayEntry {
        TodayEntry(date: .now, prompt: "What's a hill you'll die on?")
    }
    func getSnapshot(in context: Context, completion: @escaping (TodayEntry) -> Void) {
        completion(placeholder(in: context))
    }
    func getTimeline(in context: Context, completion: @escaping (Timeline<TodayEntry>) -> Void) {
        completion(Timeline(entries: [placeholder(in: context)], policy: .atEnd))
    }
}

struct TodayWidgetView: View {
    let entry: TodayEntry
    var body: some View { Text(entry.prompt).padding() }
}

struct TodayWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "TodayWidget", provider: TodayProvider()) { entry in
            TodayWidgetView(entry: entry)
        }
        .configurationDisplayName("Today's Yap")
        .description("Your daily prompt.")
    }
}

@main
struct YapWidgetBundle: WidgetBundle {
    var body: some Widget { TodayWidget() }
}
