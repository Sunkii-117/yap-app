import SwiftUI

enum YapMotion {
    static let spotlightBloom: Double = 0.5
    static let candyPress: Double = 0.09
    static let scoreCountUp: Double = 0.9
    static let streakFlicker: Double = 2.5
    // pragmatic ease-out (spec-sheet Gaps: exact curve not tokenized in the doc)
    static let ease = Animation.timingCurve(0.16, 1, 0.3, 1)
}
