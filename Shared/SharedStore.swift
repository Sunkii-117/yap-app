import Foundation

/// Small wrapper over the App Group `UserDefaults` so the app and the widget
/// read the same state. The app writes today's prompt; the widget reads it.
/// Injectable defaults keep it unit-testable without an App Group entitlement.
struct SharedStore {
    static let appGroup = "group.com.yap.shared"

    private let defaults: UserDefaults
    private enum Key { static let todayPrompt = "todayPrompt" }

    init(defaults: UserDefaults = UserDefaults(suiteName: SharedStore.appGroup) ?? .standard) {
        self.defaults = defaults
    }

    var todayPrompt: Prompt? {
        get {
            guard let data = defaults.data(forKey: Key.todayPrompt) else { return nil }
            return try? JSONDecoder().decode(Prompt.self, from: data)
        }
        nonmutating set {
            if let newValue, let data = try? JSONEncoder().encode(newValue) {
                defaults.set(data, forKey: Key.todayPrompt)
            } else {
                defaults.removeObject(forKey: Key.todayPrompt)
            }
        }
    }
}
