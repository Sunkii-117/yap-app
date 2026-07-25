import Foundation

/// Transcripts + golden metric values ported from the S1 spike samples.
/// The filler totals (17/6/13) are the validated hand-count baseline (EVAL.md);
/// they are the guard that the Swift twin equals the spike's Python/Swift metrics.
enum CoachFixtures {
    struct Sample {
        let id: String
        let transcript: String
        let durationSec: Double
        let prevWPM: Int
        let prevFillers: Int
        let expectedFillersTotal: Int
        let expectedWPM: Int
    }

    static let s1 = Sample(
        id: "s1",
        transcript: "Okay so, um, the hill I will die on is that, like, pineapple absolutely belongs on pizza. And I know, you know, everybody has like really strong feelings about this but hear me out. Um, the whole point of a good slice is like the balance, right, you've got the salty, you've got the savory, and then, i mean, the pineapple just brings this, uh, sweetness that kind of cuts through all of it. Like, think about how, um, we already put barbecue chicken on pizza and nobody, you know, loses their mind about that. So basically what I'm saying is, uh, the haters are just, like, scared of a little bit of joy. And honestly the last time I brought this up at the DMV of all places, the guy behind the counter actually agreed with me, so I feel very validated.",
        durationSec: 61, prevWPM: 172, prevFillers: 22, expectedFillersTotal: 17, expectedWPM: 141)

    static let s2 = Sample(
        id: "s2",
        transcript: "I used to think confidence was something you either had or you didn't, and, um, honestly that belief kept me stuck for years. Like, I would rehearse a sentence in my head twenty times before saying it out loud. But here is the thing I figured out, uh, confidence is not a feeling you wait for, it is basically a receipt. You do the scary thing, you survive, and your brain files away proof that you can. So now, you know, I chase the reps instead of the feeling. Every time I hit record, even when I sound clumsy, I am adding to the pile of evidence. And the wild part is the feeling eventually shows up anyway, just, uh, later than you want it to. Start before you feel ready. That is the whole trick.",
        durationSec: 57, prevWPM: 150, prevFillers: 6, expectedFillersTotal: 6, expectedWPM: 143)

    static let s3 = Sample(
        id: "s3",
        transcript: "Hot take, waking up at five a.m. does not make you disciplined, it just makes you tired. Um, we have turned this into like a personality trait, right, and I think it is kind of backwards. So the productivity crowd, you know, keeps posting these, uh, five a.m. morning routines with the cold plunge and the journaling and the forty step skincare, and, i mean, good for them honestly. But for a lot of us the actual, um, best work happens late at night when it is quiet and nobody is emailing you. Like, the goal was never the specific hour, the goal was, uh, protecting a block of time where your brain is actually on. So basically, find your hour, defend it, and, you know, stop feeling guilty that it does not start with a five.",
        durationSec: 60, prevWPM: 165, prevFillers: 19, expectedFillersTotal: 13, expectedWPM: 139)

    static let all = [s1, s2, s3]

    /// A well-formed coaching response (shape from spike prompt.md), for parser/service tests.
    static let validCoachingJSON = """
    {"score": 78, "delta_note": "fewer fillers than last time and a steadier pace.", \
    "tips": ["Lean on the pineapple-on-pizza line earlier as your hook.", \
    "Trim the 'you know' before your DMV story so it lands cleaner.", \
    "Pause after 'scared of a little bit of joy' to let it breathe."], \
    "highlight": "'scared of a little bit of joy' — a sharp, funny close that reframes the haters."}
    """
}
