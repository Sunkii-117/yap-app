import Foundation
import SwiftData

/// A persisted yap (SwiftData). Private by default; audio lives in the app container,
/// referenced by filename. Metrics are the exact code-computed values.
@Model
final class YapRecord {
    @Attribute(.unique) var id: UUID
    var createdAt: Date
    var promptId: String
    var promptText: String
    var durationSec: Double
    var transcript: String
    var audioFileName: String?
    var score: Int
    var fillersTotal: Int
    var wpm: Int
    var isPrivate: Bool

    init(
        id: UUID = UUID(),
        createdAt: Date = .now,
        promptId: String,
        promptText: String,
        durationSec: Double,
        transcript: String,
        audioFileName: String?,
        score: Int,
        fillersTotal: Int,
        wpm: Int,
        isPrivate: Bool = true
    ) {
        self.id = id
        self.createdAt = createdAt
        self.promptId = promptId
        self.promptText = promptText
        self.durationSec = durationSec
        self.transcript = transcript
        self.audioFileName = audioFileName
        self.score = score
        self.fillersTotal = fillersTotal
        self.wpm = wpm
        self.isPrivate = isPrivate
    }
}
