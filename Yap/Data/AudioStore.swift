import Foundation

/// Where recorded audio lives — a `yaps/` folder in the app's documents. Yaps are
/// local and private; nothing leaves the device without an explicit share.
enum AudioStore {
    static var directory: URL {
        let base = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("yaps", isDirectory: true)
        try? FileManager.default.createDirectory(at: base, withIntermediateDirectories: true)
        return base
    }

    static func newFileName() -> String { "\(UUID().uuidString).m4a" }
    static func url(for fileName: String) -> URL { directory.appendingPathComponent(fileName) }
}
