import Foundation

/// Sample coach output for the frontend demo. The live coach needs a deployed proxy
/// + active billing; until then the Score screen renders this. Metrics are REAL
/// (computed by `CoachMetrics` from the S1 s1 transcript); the LLM judgment is canned.
enum DemoCoachResult {
    static func make() -> CoachResult {
        let transcript = "Okay so, um, the hill I will die on is that, like, pineapple absolutely belongs on pizza. And I know, you know, everybody has like really strong feelings about this but hear me out. Um, the whole point of a good slice is like the balance, right, you've got the salty, you've got the savory, and then, i mean, the pineapple just brings this, uh, sweetness that kind of cuts through all of it. Like, think about how, um, we already put barbecue chicken on pizza and nobody, you know, loses their mind about that. So basically what I'm saying is, uh, the haters are just, like, scared of a little bit of joy. And honestly the last time I brought this up at the DMV of all places, the guy behind the counter actually agreed with me, so I feel very validated."

        let metrics = CoachMetrics.compute(transcript: transcript, durationSec: 61)
        let previous = CoachMetrics(wordCount: 150, durationSec: 60, wpm: 172, fillers: [:], fillersTotal: 22)

        let coaching = CoachCoaching(
            score: 82,
            deltaNote: "Fewer fillers than last time and a steadier pace — that's real progress.",
            tips: [
                "Open with the pineapple-on-pizza line — it's your strongest hook, don't bury it after the setup.",
                "Trim the 'you know' before the DMV story so the punchline lands cleaner.",
                "Pause a beat after \u{201C}scared of a little bit of joy\u{201D} to let it breathe."
            ],
            highlight: "\u{201C}scared of a little bit of joy\u{201D} — a sharp, funny close that flips the whole take."
        )

        return CoachResult(
            metrics: metrics,
            coaching: coaching,
            delta: MetricsDelta.between(current: metrics, previous: previous)
        )
    }
}
