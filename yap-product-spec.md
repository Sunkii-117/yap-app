# Yap — Product & MVP Specification

**Version:** 1.0
**Status:** Concept locked, ready for development planning
**Document owner:** Founder
**Last updated:** 2026-07-22

> This is a comprehensive product document. It is written so that any competent product/engineering team — human or AI — can read it top to bottom and begin development without needing the original conversation. It covers the vision, the user, the mechanics, every core flow, the AI coaching system, the content pipeline, the social layer, monetization, the recommended technical stack, the data model, and a milestone-by-milestone build plan.

---

## 0. One-line pitch

**Yap is Duolingo for speaking, wrapped in a Reels-style social feed.** You get a prompt, you talk for two minutes, an AI coach tells you exactly how to sound better, and that same recording can become a polished post, a clip you send to friends, or a public "Yap" others can respond to. Every rep makes you a better speaker, produces content, and builds a visible record of your improvement — all at once.

---

## 1. The problem & the insight

### 1.1 The problem
Writing has been coached to death: Grammarly, ChatGPT, endless templates. **Speaking has not.** Yet speaking is increasingly what carries a career or a personal brand — short-form video, podcasts, panels, standups, interviews, pitches, toasts, sales calls. Most people are quietly bad at talking off the cuff and have no low-stakes, repeatable way to get better.

### 1.2 Why existing tools fail
The market splits into three camps that never talk to each other:

| Camp | Examples | What they do | What they miss |
|---|---|---|---|
| **Delivery coaches** | Yoodli, Orai, Speeko | Score filler words & pacing | Utilities you open because you *should*, not because you *want* to. No reason to return daily. No output. No community. |
| **Content generators** | ChatGPT, Jasper, Copy.ai | Turn a text prompt into a post | Never touch how you *sound* or think out loud. Voice is an afterthought. |
| **Social/short-video** | TikTok, IG Reels, BeReal | Nail the daily-return habit | Zero coaching, zero skill framing. You don't get *better*, you just post. |

### 1.3 The insight
**Nobody treats "talking about something for two minutes" as a compounding asset.** A single spoken rep can simultaneously:
1. Build a skill (with real feedback),
2. Produce a piece of content (a post/script/clip), and
3. Leave a visible trail of improvement (a portfolio / brand artifact).

Yap is the product that makes those three things happen from **one tap of the record button.** The compounding loop is the defensible idea; the social feed is the fun that drives daily returns; the AI coach is the value that quietly accrues underneath.

---

## 2. Target users

Broad audience, unified by one trait: **they want to sound better when they talk, and they want proof or output from the reps they put in.**

### 2.1 Primary personas

**"The Habit Builder" — Maya, 24, marketing coordinator.**
Wants to be more articulate and confident but freezes on camera and in meetings. Needs a low-stakes daily rep (like Duolingo) and gentle, encouraging feedback. Success = a 30-day streak and noticeably fewer "ums."

**"The Aspiring Creator" — Deon, 29, wants to post but never does.**
Has ideas, hates writing captions, and stalls at the blank page. Yap lets him *talk* his idea out, get it cleaned into a postable script, and either publish it or practice until it's good. Success = shipping content he's proud of, consistently.

**"The High-Stakes Prepper" — Priya, 35, PM interviewing for a director role.**
Has a specific event. Wants targeted drills (behavioral answers, pitch, panel Q&A) and objective feedback on whether she's improving. Success = walking into the room calm and sharp.

**"The Skill Sharpener" — Marcus, 41, sales lead.**
Already speaks a lot; wants marginal gains and a way to benchmark himself. Loves the analytics dashboard and streaks. Success = measurable improvement in clarity/pace over a quarter.

### 2.2 Secondary / future personas
- **Teams & orgs** (sales enablement, Toastmasters-style clubs, university comms programs) — the B2B revenue path.
- **Coaches & creators** — sell prompt packs and challenges; solve content cold-start.
- **ESL / language learners** — a large adjacent market for spoken-fluency practice.

---

## 3. Core concepts & vocabulary

The product has its own light vocabulary. Use it consistently in UI and code.

| Term | Meaning |
|---|---|
| **Yap** | A single recorded talk (audio or video) on a prompt. The atomic unit of the entire product. |
| **Prompt** | The topic/question a Yap responds to. Curated, personalized, self-chosen, or another user's Yap. |
| **Yap Coach** | The AI persona that analyzes a Yap and returns feedback, scores, and tips. Encouraging, never a red pen. |
| **Yap back** | Recording your own Yap in response to someone else's — the duet/stitch-style social + practice mechanic. |
| **Streak** | Consecutive days with at least one Yap. Core retention driver. |
| **Highlight reel** | A user-curated set of their best Yaps; doubles as the public brand/portfolio artifact. |
| **Skill trend** | The time-series of a user's coaching metrics (filler rate, pace, clarity, confidence). |
| **Challenge** | A themed, often time-boxed prompt others can join and Yap back to. Virality + cohort mechanic. |

---

## 4. The core loop (in depth)

The atomic experience is: **Prompt → Record → Coach → Decide → Profile updates.** Everything else in the app is scaffolding around this loop.

```
          ┌─────────────────────────────────────────────────────────┐
          │                                                         │
          ▼                                                         │
   ┌────────────┐    ┌──────────┐    ┌──────────────┐    ┌────────────────┐
   │ 1. PROMPT  │ ─▶ │ 2. RECORD│ ─▶ │ 3. YAP COACH │ ─▶ │  4. DECIDE     │
   │            │    │ 1–3 min  │    │  analyzes    │    │  what happens  │
   └────────────┘    └──────────┘    └──────────────┘    └────────────────┘
                                                                  │
        ┌──────────────┬───────────────┬────────────────┬────────┘
        ▼              ▼               ▼                ▼
   Keep private   Polish into      Post to feed     Send to friends
   (analytics     content          (public /        (DM-style)
    only)         (post/script)    friends-only)
        │              │               │                │
        └──────────────┴───────────────┴────────────────┘
                                │
                                ▼
                    ┌──────────────────────┐
                    │ 5. PROFILE UPDATES    │
                    │ streak, skill trend,  │
                    │ highlight reel        │
                    └──────────────────────┘
```

### 4.1 Step 1 — Prompt
A user starts a Yap from one of four prompt sources:

1. **Curated library** — structured prompt sets shipped with the app, organized by skill and theme (see §5). This is the default for new users and the cold-start solution.
2. **Personalized prompt** — generated from the user's niche/goal profile and history (e.g., a "B2B SaaS founder" gets founder-flavored prompts). Adapts over time.
3. **Self-chosen / freeform** — user types their own topic. Always available.
4. **Yap back** — responding to a specific public Yap or an active Challenge. This inherits the original prompt's context.

The prompt screen shows the prompt text, an optional example/tip, a target duration, and a big **Record** button. Optionally a "surprise me" shuffle.

### 4.2 Step 2 — Record
- Audio or video (user choice; video defaults to front camera).
- Target duration 1–3 min, with a soft on-screen timer (not a hard cutoff — cutting someone off mid-thought is punishing).
- Minimal chrome while recording: prompt pinned small at top, timer, stop button. No live metrics (distracting).
- Re-record allowed freely before analysis. Nothing is public until the user explicitly chooses to make it so.
- Local-first capture: record to device, upload in background.

### 4.3 Step 3 — Yap Coach analysis
On stop, the recording is transcribed and analyzed. The user sees a brief, friendly "Coach is listening…" state, then a **feedback card** (see §6 for the full metric spec). At minimum:
- Transcript (with filler words highlighted).
- Filler-word count and rate (per minute).
- Pace (words per minute) with a "sweet spot" band.
- Clarity/structure score.
- Confidence score.
- 2–3 specific, actionable coaching tips tied to *this* Yap ("You hedged four times in the first 30 seconds — try leading with your conclusion").

Tone is paramount: encouraging first, one or two concrete improvements, never a wall of red. (See §6.5 Coach persona.)

### 4.4 Step 4 — Decide what happens to it
Every analyzed Yap can go one, some, or all of these directions. This is the fork that makes Yap more than a coaching utility:

- **Keep private** — counts toward streak and skill analytics; visible only to the user.
- **Polish into content** — AI rewrites the transcript into a chosen format (LinkedIn post, IG caption, short script, thread, newsletter blurb). User can edit, then copy or export/share out to other apps. (See §7.)
- **Post to the feed** — public or friends-only, Reels-style: the clip with waveform and auto-captions. Others can like, comment, and Yap back. (See §8.)
- **Send directly to friends** — DM-style share to specific people, Snap-style.

**Hard rule: nothing is ever posted or published automatically. Every public/outbound action requires an explicit, deliberate user tap.** (See §11 safety.)

### 4.5 Step 5 — Profile updates
Regardless of what the user does with the Yap, completing one updates:
- **Streak** (if it's the first Yap today).
- **Skill trend** dashboard (metrics appended to the time series).
- **Topics covered** / library progress.
- Eligibility to add the Yap to the **highlight reel** (public portfolio).

---

## 5. The prompt system

### 5.1 Curated library structure
Prompts ship organized on two axes so the app can recommend intelligently:

- **By skill:** storytelling, explaining a concept simply, persuasion / hot takes, concise answers, thinking on your feet, emotional delivery, hooks & openings.
- **By theme/use case:** interview prep, pitch practice, content ideas for your niche, everyday confidence, toasts & speeches, debate/disagreement.

Each prompt carries metadata: `skill`, `theme`, `difficulty (1–3)`, `target_duration`, optional `example`, optional `structure_hint` (e.g., "Try: hook → story → lesson").

### 5.2 Personalization over time
- **Onboarding** captures a lightweight profile: primary goal (get confident / make content / prep for an event / general), niche (optional free text or picker), and preferred format (video/audio).
- New users get the generic curated library.
- As history accumulates, the app blends in **personalized prompts** generated from niche + goal + weak-skill signals (e.g., if clarity scores lag on "explain simply," surface more of those).
- Difficulty adapts: consistent high scores unlock harder prompts.

### 5.3 Challenges & trending prompts (V1.5+)
- Time-boxed themed prompts anyone can Yap back to (e.g., "Your most embarrassing work story in 60s").
- Surfaced on the feed; drive both virality and volume of practice reps.
- Can be authored by the Yap team, by creators/coaches (marketplace), or by orgs (team challenges).

---

## 6. The Yap Coach (AI analysis) — full spec

This is the core value engine. Precision and tone both matter.

### 6.1 Pipeline
1. **Transcription** with word-level timestamps and (ideally) confidence + non-speech markers.
2. **Deterministic metrics** computed from the transcript/timestamps in code (cheap, fast, objective).
3. **LLM analysis** for the qualitative, structural, and coaching layer (using Claude).
4. **Feedback card** assembly and persistence to the skill trend.

### 6.2 Deterministic metrics (computed in code, not by the LLM)
Compute these directly for objectivity, speed, and cost:
- **Filler-word count & rate/min** — configurable list ("um," "uh," "like," "you know," "basically," "actually," "so," "kind of," "right?"). Rate normalizes for length.
- **Pace (WPM)** overall and windowed (to catch rushing/slowing). Sweet-spot band ~130–160 WPM for conversational clarity (tunable).
- **Pause analysis** — count/length of silences; distinguish "thoughtful pause" from "dead air / filler-pause."
- **Talk time / duration** vs. target.
- **Vocabulary variety** — type-token ratio as a light lexical-richness signal.
- **Repetition** — repeated phrases/crutch words beyond fillers.

### 6.3 LLM-driven metrics & feedback (Claude)
The LLM receives the transcript, the deterministic metrics, the prompt, and the user's goal/history, and returns a **structured JSON** result:
- **Clarity / structure score (0–100)** — did it have a discernible shape (hook → point → support → close)? Was it easy to follow?
- **Confidence score (0–100)** — hedging, qualifiers, trailing off, vs. assertive delivery. (Text-based proxy in MVP; audio prosody later.)
- **Hook strength** — did the opening earn attention?
- **Structure map** — labels segments (hook/body/close) so we can show the user their arc.
- **2–3 coaching tips** — specific, tied to this Yap, phrased encouragingly, each with a concrete "try this next time."
- **One-line highlight** — the single best moment ("Your line about X was genuinely sharp").

> **Model recommendation:** use **Claude** for the analysis layer. Default to **`claude-sonnet-5`** for the balance of quality and cost per analysis; consider **`claude-haiku-4-5-20251001`** for cheap high-volume paths (e.g., free-tier quick feedback) and **`claude-opus-4-8`** for premium deep-dive reports. Always request structured JSON output and validate it. (Verify current model IDs/pricing against the Claude API docs at build time.)

### 6.4 Roadmap: audio/prosody analysis (later)
MVP infers confidence/energy from *text*. A later milestone adds **acoustic analysis** — pitch variation, energy, actual pause detection from audio, tone/sentiment — for far richer delivery coaching. This is a meaningful upsell surface and a moat.

### 6.5 Coach persona (non-negotiable design constraint)
Coaching apps die when they feel naggy or judgmental. The Yap Coach must read as an encouraging mentor:
- **Praise first**, always name something that worked.
- **At most 2–3 improvements** per session; never a laundry list.
- Frame as forward-looking ("next time try…"), not corrective ("you failed to…").
- Celebrate deltas ("half as many fillers as last week — that's real progress").
- Configurable intensity: a "go easy on me" vs. "push me hard" toggle.

---

## 7. The content pipeline

Turns a spoken rep into shareable text/clips. This is the "content generation" pillar.

### 7.1 Polish-into-content
From any analyzed Yap, the user picks a target format; the LLM rewrites the transcript into it while preserving their voice:
- **LinkedIn post** (professional, hook + insight + takeaway).
- **Instagram / TikTok caption** (short, punchy).
- **Short-form video script** (tightened version of what they said, for a re-record or teleprompt).
- **Thread** (multi-part).
- **Newsletter blurb** (longer).

Rules:
- Preserve the user's actual phrasing and ideas — clean it up, don't ghost-write a different person.
- Always editable before it leaves the app.
- Offer a "keep it raw" option (light cleanup only) for authenticity purists.

### 7.2 Clip generation
For video Yaps: auto-captions (from the transcript), waveform for audio-only, and eventually auto-trimmed highlight clips (find the best 30s). Export with captions burned in.

### 7.3 Export & share-out
- Copy to clipboard, native share sheet, download video/audio.
- **Later:** direct multi-platform publishing (TikTok/IG/LinkedIn/X via their APIs) — a Pro feature. Still gated behind an explicit publish tap.

---

## 8. The social layer

This turns Yap from a solo utility into a habit-forming social product. **Sequenced deliberately after individual retention is proven** (see §12 milestones & §11 cold-start).

### 8.1 The feed
- Reels-style vertical feed of Yaps: the clip (video or audio+waveform), captions, prompt shown as context, creator handle, like/comment/Yap-back controls.
- **Scopes:** Public (discover) and Friends-only. User chooses per-post at share time; default is private.
- **Ranking:** start simple (recency + follows + light engagement weighting). Sophisticated recommendation is a later concern; do not over-build ranking pre-network-density.

### 8.2 Interactions
- **Like** and **comment** (text; voice-comment is a fun later option).
- **Yap back** — the flagship mechanic. Record your own Yap in response; it links to the original and can appear as a duet/thread. This is simultaneously (a) engagement, (b) virality (pulls in the responder's network), and (c) *more free practice reps for the responder*. The social loop directly feeds the skill loop.
- **Follow** graph; friends via contacts/handles.
- **Send to friends** — DM-style direct shares (can be private, not on any feed).

### 8.3 Challenges (community)
Themed, joinable, time-boxed prompts with their own mini-feed of responses. Leaderboards optional. Great for orgs, creators, and seasonal virality.

### 8.4 Moderation (required from day one of the feed)
Public feed + comments = harassment, spam, and abuse risk from launch:
- Report/block/mute on Yaps, comments, and users.
- Automated first-pass moderation on transcripts/comments (LLM classifier + keyword/heuristics) before human review queue.
- Clear community guidelines; escalation path; rate limits on new accounts.
- Minor-safety considerations if under-18 users are allowed (age gating, restricted discovery).

---

## 9. Analytics, gamification & the personal-brand profile

### 9.1 Personal analytics (the "get better" proof)
A dashboard showing skill trends over time:
- Filler rate/min, pace, clarity, confidence — each as a sparkline with deltas.
- Topics/skills covered vs. remaining (library progress).
- Best-ever and personal-record callouts.
- Per-Yap history with the ability to replay + re-read old feedback.

### 9.2 Gamification
- **Streaks** (the core habit engine) with streak-freeze/repair mechanics to avoid punishing single misses.
- **Levels / XP** per skill.
- **Badges** for milestones (first Yap, 7-day streak, 100 Yaps, "filler-slayer," etc.).
- **Weekly goals** and gentle reminders/notifications (mobile).

### 9.3 The public profile / highlight reel (the "personal brand" pillar)
- A shareable profile page: handle, bio, niche, a curated **highlight reel** of best Yaps, and optionally public stats ("312 Yaps, clarity up 34%").
- Doubles as a portfolio link — useful for creators, job-seekers, speakers.
- User controls exactly what's public. Stats can be shown or hidden.

---

## 10. Monetization

**Freemium, with B2B as the likely real revenue.**

### 10.1 Free tier
- Daily cap on Yaps (e.g., 3/day).
- Basic feedback (filler count, pace, one or two tips).
- One export format.
- Access to curated library + social feed.

### 10.2 Yap Pro (consumer subscription)
- Unlimited Yaps.
- Full analytics & skill trends.
- All export formats + (later) direct multi-platform publishing.
- Personalized/adaptive prompts.
- Deep-dive reports (Opus-tier analysis), acoustic/prosody analysis when available.
- Priority processing.

### 10.3 Teams / B2B (highest-value path)
Sales orgs, clubs, universities, corporate L&D already pay for speaking coaching. Sell:
- Team dashboards & admin.
- Private cohort challenges.
- Aggregate + per-member progress reporting.
- Seat-based pricing.

### 10.4 Marketplace (later)
Coaches/creators sell prompt packs and challenges; revenue share. Doubles as a content cold-start solution (seeds prompts and, via their audiences, users).

---

## 11. Key risks & mitigations

| Risk | Mitigation |
|---|---|
| **Feed cold-start** (social apps die without density) | Launch the coach+content loop *without* a public feed. Prove solo retention first; add the feed once there's a base to seed. Friends-first before public discovery. |
| **Moderation burden** | Report/block/mute + automated first-pass classification from day one of the feed. Rate limits on new accounts. |
| **Unit economics** (transcription + LLM + video hosting at scale) | Model cost per Yap early. Use cheap models (Haiku) on free tier, deterministic metrics in code, aggressive caching, tiered processing. Cap free-tier volume. |
| **Coach tone** (naggy = churn) | Encouraging persona is a hard design constraint (§6.5). Intensity toggle. Praise-first. |
| **Privacy / accidental publishing** | *Nothing* is public by default; every outbound action needs an explicit tap. Clear per-post scope selection. Easy delete. |
| **Camera shyness** (people fear recording themselves) | Audio-first option, private-by-default, low-stakes framing, "nobody sees this unless you choose." |
| **Content authenticity** (AI polish sounding fake) | Preserve user's voice; "keep it raw" mode; always editable. |

---

## 12. Development milestones

Each milestone is a shippable, evaluable slice. Do not build the social feed before solo retention is proven.

### **M0 — Foundations & spike (pre-MVP)**
- Repo, CI, environments, auth (email + Apple/Google sign-in).
- Cross-platform app shell (mobile-first, web companion) — see §13 stack.
- **De-risking spike:** record → upload → transcribe → deterministic metrics → LLM feedback → render a card. Prove the pipeline end-to-end on one hardcoded prompt before building around it.
- Basic telemetry/analytics instrumentation.

### **M1 — The solo core loop (MVP)**
*Goal: a person can build a daily speaking habit and see themselves improve.*
- Curated prompt library (skill + theme organized).
- Record (audio + video), local-first capture, background upload.
- Yap Coach: transcript, filler count/rate, pace, clarity + confidence scores, 2–3 tips, encouraging persona.
- Private Yap history + replay + past feedback.
- Streaks + basic skill-trend dashboard.
- Onboarding that captures goal/niche/format.
- **No social feed yet.**
- **Exit criteria:** measurable D7/D30 retention and repeat-session rate that justify building outward.

### **M2 — Content pipeline & sharing-out**
*Goal: reps produce shareable content.*
- Polish-into-content (2–3 formats to start: LinkedIn post, caption, script).
- Auto-captions for video; export/download; native share sheet.
- "Send to friends" (direct share) — lightweight, no public feed required.
- Personalized prompts begin (blend into the library).

### **M3 — The social feed (V1.5)**
*Goal: turn it into a returning social product — only after M1 retention is real.*
- Public + friends-only feed, likes, comments.
- **Yap back** (duet/response mechanic).
- Follow graph, friends via contacts/handles.
- Public profile + highlight reel.
- **Moderation from day one** (report/block/mute + automated first-pass).
- Trending prompts.

### **M4 — Monetization & retention depth**
- Yap Pro subscription (paywall, entitlements, billing).
- Full analytics, all export formats, adaptive difficulty.
- Challenges (community, time-boxed).
- Deep-dive reports (Opus-tier).

### **M5 — Expansion**
- Acoustic/prosody analysis (pitch, energy, real pause detection, tone).
- Direct multi-platform publishing (TikTok/IG/LinkedIn/X APIs).
- Teams/B2B tier (dashboards, cohorts, seats).
- Coach/creator marketplace.
- Auto-edited highlight clips; richer feed ranking.

---

## 13. Recommended technical stack

Chosen for mobile-first cross-platform, fast iteration, and a clean path to scale. Treat as a strong default, not dogma.

### 13.1 Client
- **React Native + Expo** for iOS/Android from one codebase; **Expo for Web** (or a thin Next.js companion) for the web experience. Mobile-first as decided.
- Native modules for camera/mic/recording where Expo's aren't enough.
- Local-first capture; background upload with resumability.

### 13.2 Backend
- **Node.js (TypeScript)** API — either a managed platform (e.g., serverless functions) or a small service; keep the analysis pipeline as an async job queue (record/upload is fast; transcription+LLM is seconds).
- **Postgres** as the primary datastore (see §14 data model).
- **Object storage + a video platform** for media: e.g., **Mux** or **Cloudflare Stream** for video ingest/transcode/delivery + thumbnails/captions; plain object storage (S3/R2) for audio.
- **Job queue** (e.g., a managed queue / Redis-backed) for the async analysis pipeline.

### 13.3 AI / ML services
- **Transcription:** a word-timestamped ASR — **Deepgram**, **AssemblyAI**, or **Whisper** (hosted). Need word-level timestamps for metrics.
- **LLM coaching & content generation:** **Claude** — `claude-sonnet-5` default, `claude-haiku-4-5-20251001` for cheap/high-volume, `claude-opus-4-8` for premium deep dives. Structured JSON outputs, validated. (Confirm current model IDs/pricing at build time.)
- **Deterministic metrics** computed in-code from transcripts (no model needed).
- **Moderation:** LLM classifier + heuristics for first-pass; human review queue.

### 13.4 Cross-cutting
- **Auth:** managed provider (Apple/Google/email).
- **Billing:** RevenueCat (mobile subscriptions) or Stripe (web/B2B).
- **Analytics/telemetry:** product analytics (e.g., PostHog/Amplitude) from M0.
- **Notifications:** push (streak reminders, social) — respect frequency limits.
- **Feature flags** for milestone gating and experiments.

---

## 14. Data model (core entities)

Enough to start; expand per milestone.

```
User
  id, handle, email, auth_provider, created_at
  profile: display_name, bio, niche, primary_goal, preferred_format
  settings: coach_intensity, default_privacy, notif_prefs

Prompt
  id, text, skill, theme, difficulty, target_duration
  example?, structure_hint?
  source: curated | personalized | user | challenge
  author_id?  (for creator/coach/org prompts)

Yap                       -- the atomic unit
  id, user_id, prompt_id
  media_ref (video/audio), media_type, duration
  transcript (with word timestamps)
  privacy: private | friends | public
  created_at
  -> Analysis (1:1)
  parent_yap_id?          -- set when this is a "Yap back"
  challenge_id?

Analysis
  id, yap_id
  filler_count, filler_rate, wpm, pause_stats, ttr, repetition
  clarity_score, confidence_score, hook_strength
  structure_map (json)
  tips (json array), highlight_line
  model_used, created_at

SkillTrendPoint           -- derived, for the dashboard
  id, user_id, yap_id, metric, value, created_at

ContentAsset              -- a polished output derived from a Yap
  id, yap_id, format, text, edited_by_user (bool), created_at

Social
  Follow(follower_id, followee_id, created_at)
  Like(user_id, yap_id, created_at)
  Comment(id, user_id, yap_id, text, created_at)
  DirectShare(id, from_user_id, to_user_id, yap_id, created_at)

Challenge
  id, title, prompt_id, starts_at, ends_at, author_id, scope

Streak
  user_id, current_len, longest_len, last_yap_date, freezes_available

Subscription
  user_id, tier (free|pro|team), status, renews_at, provider_ref

ModerationEvent
  id, target_type (yap|comment|user), target_id, reason, status, created_at
```

---

## 15. Success metrics (KPIs)

**Habit / retention (the make-or-break for M1):**
- D1 / D7 / D30 retention.
- Weekly active Yappers; average Yaps per active user per week.
- Streak distribution; % reaching 7-day streak.

**Skill value (is the coaching working?):**
- Cohort improvement in filler rate / clarity / confidence over N sessions.
- Self-reported confidence lift (periodic survey).

**Content pipeline:**
- % of Yaps polished into content; % exported/shared out.

**Social (M3+):**
- Yap-back rate; K-factor / invites per user; feed engagement.

**Business:**
- Free→Pro conversion; MRR; B2B seats; CAC/LTV; cost per Yap (unit economics).

---

## 16. Open questions to resolve during planning

1. **Video vs. audio default** — camera shyness vs. richer content. Likely audio-first, video encouraged.
2. **Under-18 policy** — allowed? If so, age gating + restricted discovery + heavier moderation.
3. **How raw should "polish" be** — where's the line between cleanup and ghost-writing? Needs UX + user testing.
4. **Free-tier generosity vs. cost** — exact caps depend on unit-economics modeling in M0.
5. **Web scope** — full parity or a review/edit companion only? (Mobile-first suggests the latter initially.)
6. **Ranking algorithm timing** — how long can recency-based feed survive before it needs real recommendation?
7. **Data & privacy** — recordings are sensitive personal media; retention, deletion, and (for B2B) data-handling commitments need a clear policy early.

---

## 17. Summary

Yap unifies three things nobody has combined: **deliberate speaking practice with real feedback, a voice-to-content pipeline, and a social feed that makes reps fun and viral.** The atomic unit is a two-minute talk that simultaneously improves a skill, produces content, and builds a visible record. The AI Yap Coach is the value; the social "Yap back" loop is the growth engine; the compounding of reps is the moat.

Build order is deliberate: **prove the solo coaching loop retains people (M1), then give reps an output (M2), then make it social (M3), then monetize and deepen (M4–M5).** Do not build the feed before solo retention is real — that sequencing is the single most important strategic decision in this document.
