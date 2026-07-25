import Foundation

/// The topic/question a yap responds to. The atomic input of the core loop.
struct Prompt: Codable, Identifiable, Equatable {
    let id: String
    let text: String
    let skill: String          // storytelling | hot-take | explain | persuasion
    let theme: String          // food | culture | work | ...
    let difficulty: Int        // 1...3
    let targetDurationSec: Int // soft target, not a hard cutoff
}
