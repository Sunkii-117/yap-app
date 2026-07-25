import Foundation

/// Curated seed prompts — provocation-first (PRD §8): hot takes, story hooks,
/// hills to die on. New users draw from this; personalization comes later.
enum PromptLibrary {
    static let all: [Prompt] = [
        Prompt(id: "hill-you-die-on", text: "What's a hill you'll die on?",
               skill: "hot-take", theme: "opinion", difficulty: 2, targetDurationSec: 60),
        Prompt(id: "overrated", text: "Name something everyone loves that's actually overrated — and defend it.",
               skill: "persuasion", theme: "culture", difficulty: 2, targetDurationSec: 60),
        Prompt(id: "embarrassing-work", text: "What's the most embarrassing thing you've done at work?",
               skill: "storytelling", theme: "work", difficulty: 1, targetDurationSec: 60),
        Prompt(id: "changed-mind", text: "What's something you've completely changed your mind about?",
               skill: "storytelling", theme: "growth", difficulty: 2, targetDurationSec: 75),
        Prompt(id: "bad-advice", text: "What's a piece of popular advice you think is garbage?",
               skill: "hot-take", theme: "culture", difficulty: 2, targetDurationSec: 60),
        Prompt(id: "useless-talent", text: "What's a weirdly specific talent you have that's completely useless?",
               skill: "storytelling", theme: "personal", difficulty: 1, targetDurationSec: 45),
        Prompt(id: "reheat-crime", text: "Which food is a crime to reheat — and why are you right?",
               skill: "hot-take", theme: "food", difficulty: 1, targetDurationSec: 45),
        Prompt(id: "first-impression", text: "What do people get wrong about you when they first meet you?",
               skill: "storytelling", theme: "personal", difficulty: 2, targetDurationSec: 60),
        Prompt(id: "overpriced", text: "What's something people spend way too much money on?",
               skill: "persuasion", theme: "money", difficulty: 2, targetDurationSec: 60),
        Prompt(id: "irrational-anger", text: "What tiny, meaningless thing makes you irrationally angry?",
               skill: "storytelling", theme: "personal", difficulty: 1, targetDurationSec: 45),
        Prompt(id: "secret-genius", text: "What's a 'dumb' thing you do that's secretly genius?",
               skill: "persuasion", theme: "personal", difficulty: 2, targetDurationSec: 60),
        Prompt(id: "defend-bad-movie", text: "Defend a movie everybody else loves to hate.",
               skill: "persuasion", theme: "culture", difficulty: 3, targetDurationSec: 75),
        Prompt(id: "rebrand-boring", text: "If you could rebrand one boring thing to be cool, what would it be?",
               skill: "hot-take", theme: "ideas", difficulty: 3, targetDurationSec: 60),
        Prompt(id: "teach-60s", text: "Teach me something you could talk about for hours — in 60 seconds.",
               skill: "explain", theme: "ideas", difficulty: 3, targetDurationSec: 60),
    ]
}
