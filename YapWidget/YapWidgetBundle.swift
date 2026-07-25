import WidgetKit
import SwiftUI

struct TodayEntry: TimelineEntry {
    let date: Date
    let prompt: Prompt
}

struct TodayProvider: TimelineProvider {
    /// Prefer what the app wrote to the App Group; fall back to the deterministic
    /// provider so a fresh install's widget still shows the right prompt.
    private func currentPrompt() -> Prompt {
        SharedStore().todayPrompt ?? PromptProvider(library: PromptLibrary.all).prompt(for: .now)
    }

    func placeholder(in context: Context) -> TodayEntry {
        TodayEntry(date: .now, prompt: PromptLibrary.all[0])
    }

    func getSnapshot(in context: Context, completion: @escaping (TodayEntry) -> Void) {
        completion(TodayEntry(date: .now, prompt: currentPrompt()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<TodayEntry>) -> Void) {
        let entry = TodayEntry(date: .now, prompt: currentPrompt())
        let cal = Calendar.current
        let nextMidnight = cal.date(byAdding: .day, value: 1, to: cal.startOfDay(for: .now))
            ?? Date.now.addingTimeInterval(86_400)
        completion(Timeline(entries: [entry], policy: .after(nextMidnight)))
    }
}

struct TodayWidgetView: View {
    @Environment(\.widgetFamily) private var family
    let entry: TodayEntry

    var body: some View {
        VStack(alignment: .leading, spacing: family == .systemSmall ? 6 : 10) {
            Text("TODAY'S YAP")
                .font(.system(size: family == .systemSmall ? 10 : 12, weight: .heavy))
                .tracking(1.2)
                .foregroundStyle(YapColor.foilGold)

            Text(entry.prompt.text)
                .font(.system(size: promptSize, weight: .bold, design: .serif))
                .foregroundStyle(YapColor.textWhite)
                .minimumScaleFactor(0.7)
                .lineLimit(family == .systemSmall ? 4 : 6)
                .accessibilityLabel("Today's prompt: \(entry.prompt.text)")

            if family != .systemSmall { Spacer(minLength: 0) }

            HStack(spacing: 4) {
                Text("Yap it").font(.system(size: family == .systemSmall ? 12 : 14, weight: .heavy))
                Image(systemName: "arrow.right")
            }
            .foregroundStyle(YapColor.studioInk)
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(YapColor.foilGold, in: Capsule())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .containerBackground(for: .widget) {
            LinearGradient(colors: [YapColor.studioGrape, YapColor.studioInk],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
        }
        .widgetURL(URL(string: "yap://today"))
    }

    private var promptSize: CGFloat {
        switch family {
        case .systemSmall:  return 15
        case .systemMedium: return 19
        default:            return 24
        }
    }
}

struct TodayWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "TodayWidget", provider: TodayProvider()) { entry in
            TodayWidgetView(entry: entry)
        }
        .configurationDisplayName("Today's Yap")
        .description("Your daily prompt, front and center.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

@main
struct YapWidgetBundle: WidgetBundle {
    var body: some Widget { TodayWidget() }
}
