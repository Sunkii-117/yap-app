# Yap — Product Requirements Document (PRD)

**Version:** 1.0
**Status:** Ready for planning / eng scoping
**Owner:** Founder
**Companion docs:** `yap-product-spec.md` (vision), `yap-competitive-landscape.md` (market research)
**Last updated:** 2026-07-22

---

## 0. How to read this document

This PRD is the buildable blueprint for Yap. The vision lives in `yap-product-spec.md`; this document turns that vision into concrete, scoped requirements a team can build from — screens, features, AI behavior, data, acceptance criteria, and release order.

It is written around a **deliberately narrow target user and four locked product decisions** (see §2–3). Everything downstream — defaults, prompts, coach tone, feed design — follows from those. When a requirement seems opinionated, that's why: the opinions are the point.

---

## 1. Product summary

**Yap is a daily-habit app that makes you good at talking to camera — telling a story, landing a hot take, thinking out loud — and turns those reps into content you can actually post.**

Each day you get a prompt (on your home screen via an iOS widget). You tell **Yapbot**, the AI coach, roughly what you want to say; it helps you shape a tight ~60-second yap. You record, and instantly get a score, a filler-word count, and 2–3 specific coaching tips measured against your last yap. You keep your reps private, send them to friends, or post the good ones. Over time you build a streak, a curated profile, and a highlight reel that doubles as proof you can talk.

**Positioning line:** *Couch-to-5K for talking to camera — for the people who want to post but freeze at the record button.*

---

## 2. Target user (locked)

**Primary user — "the aspiring yapper."** Someone who *wants* to build a personal brand / start posting short-form video, has watched the "yapping" trend explode, and can't make themselves hit record. They freeze on camera, ramble, hate how they sound, and never ship. They are not a professional speaker and not a language learner. They have an itch they feel *today*.

**Why this user, not "everyone":** "everyone who wants to speak better" has no acute pain and no retention. This user has a specific, current, emotional problem (I want to post and I can't) and a clear finish line (I posted something I'm proud of). That specificity drives every default below.

**Secondary users (later, not v1):** high-stakes preppers (interview/pitch), sales/founders, ESL learners, teams. Explicitly out of scope for the initial build (see §5 Non-goals).

### Personas
- **Maya, 24** — wants to post lifestyle/opinion content, records 5 takes, hates all of them, deletes. Needs low-stakes reps + proof she's improving.
- **Deon, 29** — has takes for days, freezes the second the camera's on. Needs Yapbot to help him structure the ramble and a safe place to practice.
- **Priya, 35** *(secondary/later)* — prepping for a specific event. A future "event mode," not a v1 identity.

---

## 3. Locked product decisions

These four decisions are settled and everything in this PRD assumes them. Changing one means re-scoping.

1. **Practice is the front door; content is the reward.** The default session is a practice rep with feedback. Turning a yap into a polished post is something you *unlock* once a take is good ("this one's ready to post"), not a parallel mode you pick up front.
2. **The feed is a dojo, not a stage.** Default privacy is **private**. The social layer is framed as a room of fellow beginners leveling up, where being rough is the premise. It does not try to compete with TikTok on content quality.
3. **The first rep is engineered to be un-scary.** First-ever yap: audio-only option, ~15 seconds, no score shown, permanently private. Video and scoring are earned, not forced on day one.
4. **The coach tracks deltas, it does not grade.** Feedback always compares you to your own recent yaps ("half the fillers you had last week"). No absolute 1–10 "you're a bad speaker" verdicts. Harshness is a user-controlled dial, gentle by default.

---

## 4. Goals

**Product goals (what success looks like for the user):**
- Get a scared beginner to complete their first yap in <2 minutes of opening the app.
- Build a daily speaking habit (streak) that survives past week 1.
- Produce, within the first week, at least one yap the user feels good enough to share.
- Make measurable improvement *visible* (filler count and clarity trending down/up over time).

**Business goals:**
- Prove solo retention (see §5 metrics) *before* investing in the public feed.
- Convert engaged free users to Yap Pro.
- Build a content + network moat (yaps + friends graph) that a pure-utility competitor can't copy.

---

## 5. Non-goals (v1) & success metrics

### Non-goals (explicitly out of scope for the first build)
- No public/global discovery feed at launch (friends + private only first — see §12 release plan).
- No interview-prep mode, meeting/Zoom real-time coach, or ESL mode.
- No Android at launch (iOS-first; the widget is a core mechanic). Android follows.
- No web app beyond a minimal shareable public-profile page.
- No direct multi-platform auto-posting at launch (export/share-sheet only).
- No acoustic/prosody analysis at launch (text-based coaching first).

### Success metrics (KPIs)
**North Star:** *weekly retained yappers* — users who record ≥3 yaps/week in a given week and return the next week.

- **Activation:** % of new users who complete a first yap in their first session (target: high — the un-scary first rep exists for this).
- **Habit:** D1 / D7 / D30 retention; % reaching a 7-day streak; avg yaps/user/week.
- **Value proof:** cohort trend in filler rate & clarity over first 20 yaps; % of users who share or export ≥1 yap in week 1.
- **Social (once shipped):** % of yaps sent to friends; yap-back rate; invites/user.
- **Business:** free→Pro conversion; cost per yap (unit economics); MRR.

**Gate:** do not build the public feed (§12, M3) until D7 retention and weekly-retained-yapper numbers clear an agreed bar on the solo loop.

---

## 6. The core loop (reference)

```
  iOS WIDGET            IN-APP
  ┌──────────┐   tap    ┌────────────────────────────────────────────┐
  │ Today's  │ ───────▶ │ 1. Yapbot: "what do you want to say?"      │
  │ prompt   │          │    → helps script a ~60s yap               │
  │ + streak │          │ 2. Record (audio or video)                 │
  └──────────┘          │ 3. Score + filler count + 2–3 delta tips   │
                        │ 4. Decide: keep private / send to friends /│
                        │    (if good) polish & post                 │
                        │ 5. Streak +1, skill trend + profile update │
                        └────────────────────────────────────────────┘
```

Everything in §7 is a component of this loop or scaffolding around it.

---

## 7. Feature requirements

Each feature: **what it is**, **user stories**, **requirements**, **acceptance criteria (AC)**. Priority tags: `[MVP]` = first build, `[V1.5]`, `[Later]`.

### 7.1 Onboarding & the un-scary first rep `[MVP]`
**What:** First-run flow that captures a light profile and gets the user through one successful, fear-free yap.

**User stories:**
- As a nervous first-timer, I want my first recording to feel impossible to fail, so I don't bail.
- As a new user, I want the app to learn what I care about, so my prompts feel like me.

**Requirements:**
- Auth: Sign in with Apple + Google + email.
- Capture in onboarding: primary goal (start posting / get more confident / just curious), 3–5 interest tags (free text or picker: e.g. sports takes, work stories, pop culture, fitness, tech), preferred default format (audio/video).
- First yap is forced into the un-scary configuration: **audio-only default, ~15s target, no score screen, permanently private**, with copy that says so up front.
- After the first yap, reveal the real loop (scoring, streak, Yapbot) as a light "here's what you unlocked" moment.

**AC:**
- A brand-new user can go from app-open to first completed yap in under ~2 minutes with no dead ends.
- The first yap never displays a numeric score.
- Interests captured in onboarding measurably influence the first curated prompt.

### 7.2 Daily prompt + iOS widget `[MVP]`
**What:** One prompt per day, surfaced on the home screen via a widget, that pulls the user into a yap.

**User stories:**
- As a habit-builder, I want to see today's prompt on my home screen so I'm nudged without opening the app.
- As a returning user, I want my streak visible so I don't want to break it.

**Requirements:**
- iOS home-screen widget (small + medium sizes) showing: today's prompt, current streak, and a tap-to-yap affordance that deep-links straight into the record flow for today's prompt.
- One primary daily prompt per user, refreshed daily, personalized over time (§7.9). New users draw from the curated library.
- Push notification for the daily prompt at a user-set (or smart-default) time; respects frequency limits.
- Prompt style is provocation-first (hot take to defend, story to tell), not "describe your day" — see §8 prompt design.

**AC:**
- Widget renders today's prompt + streak and deep-links into the correct prompt's record screen.
- Missing a day resets/handles the streak per §7.6 rules.

### 7.3 Yapbot — the scripting coach `[MVP]`
**What:** The conversational AI that helps the user shape what they're going to say *before* recording, and coaches *after*.

**User stories:**
- As someone who freezes, I want help turning my vague idea into a tight little script so I'm not staring at a blank prompt.
- As a user with opinions, I want to tell the bot my actual take and have it help me land it.

**Requirements (pre-record scripting):**
- Entry: from the prompt screen, user can (a) just record, or (b) "help me with this" → Yapbot.
- User tells Yapbot, in text or voice, roughly what they want to say (their angle, story, take).
- Yapbot returns a short, speakable scaffold: a strong opening line/hook, 2–3 beats, and a closer — tuned to the user's interests and past yaps, in a natural spoken register (not an essay).
- Scaffold is a *guide, not a teleprompter script to read verbatim* — copy should encourage the user to make it their own. Optional teleprompt overlay while recording is `[V1.5]`.
- User can ask for another angle, punch it up, make it funnier/shorter, etc.

**Requirements (post-record coaching):** see §7.5.

**AC:**
- Given a user's stated angle + interests, Yapbot returns a scaffold with a clear hook, middle, and close in a conversational tone.
- Yapbot never blocks recording — "just record" is always one tap away.

### 7.4 Recording `[MVP]`
**What:** The capture experience.

**Requirements:**
- Audio or video (user choice; video defaults to front camera). Audio-only is a first-class citizen (fear reduction).
- Soft timer toward the target duration (default ~60s; ~15s for first rep); **no hard cutoff** mid-sentence.
- Minimal on-screen chrome while recording: small prompt reminder, timer, stop. No live metrics.
- Optional teleprompt overlay of the Yapbot scaffold `[V1.5]`.
- Free re-record before analysis; nothing leaves the device/private state without an explicit action.
- Local-first capture; background upload with retry/resumability.

**AC:**
- User can record audio-only or video, review, re-record, and proceed to analysis.
- No yap becomes visible to anyone else without an explicit share action.

### 7.5 Scoring & coaching (the AI analysis) `[MVP]`
**What:** The feedback the user gets right after recording. The core value.

**Pipeline:** transcription (word-timestamps) → deterministic metrics in code → LLM coaching layer → feedback card → append to skill trend.

**Deterministic metrics (computed in code):**
- Filler-word count + rate/min (configurable list: um, uh, like, you know, basically, actually, so, kind of, right?).
- Pace (WPM), overall + windowed, with a "sweet spot" band.
- Pause/dead-air analysis.
- Duration vs. target; vocabulary variety (TTR); crutch-phrase repetition.

**LLM coaching layer (Claude, structured JSON out):**
- Clarity/structure read (did it have a hook → point → close shape; was it easy to follow).
- Confidence read (hedging/trailing-off vs. assertive) — text-based proxy in v1.
- Hook strength.
- **2–3 specific, forward-looking tips** tied to *this* yap.
- One genuine highlight ("your line about X actually landed").

**The score (locked design):**
- A single friendly **Yap Score** is shown, but framed as **movement, not judgment**: always presented next to the user's own recent trend ("+6 vs. your last one"). No public leaderboard of absolute scores in v1.
- Harshness dial in settings (gentle ↔ push me), gentle by default.

**User stories:**
- As an anxious user, I want feedback that shows I'm improving, so I keep going.
- As an improving user, I want specific, actionable tips, not generic praise.

**AC:**
- After recording, user sees: transcript (fillers highlighted), filler count/rate, pace, Yap Score with delta vs. last yap, 2–3 specific tips, one highlight.
- Feedback tone matches the harshness setting; default never reads as harsh.
- No absolute "you are a X/10 speaker" verdict is ever shown.

### 7.6 Streaks & habit `[MVP]`
**What:** The retention engine.

**Requirements:**
- Streak = consecutive days with ≥1 completed yap. Shown in-app and on the widget.
- Streak-freeze / repair mechanic so a single miss doesn't nuke a long streak (avoid punishing lapses).
- Milestone badges (first yap, 3-day, 7-day, 30-day, 100 yaps, "half the fillers," etc.).
- Gentle reminder notifications; user-configurable timing and frequency.

**AC:**
- Streak increments once per calendar day on first completed yap; freeze logic behaves per spec; widget reflects current streak.

### 7.7 Sharing: send to friends & export `[MVP]`
**What:** The lowest-friction social action — sending a yap to specific people — plus export.

**User stories:**
- As a user proud of a yap, I want to send it straight to a friend, like a Snap.
- As an aspiring creator, I want to export a good yap to post it elsewhere.

**Requirements:**
- From any yap: keep private (default), **send to friends** (direct, to specific people), or export via native share sheet / download (video with burned-in captions, or audio + waveform).
- Auto-captions generated from the transcript for video yaps.
- "Polish into content" (§7.10) is offered specifically when a yap scores well ("this one's ready — want a caption/post?").
- **Every outbound action requires an explicit tap. Nothing auto-posts.**

**AC:**
- User can send a yap to one or more friends, and separately export/share it out, from the post-analysis screen.
- Exported video includes captions.

### 7.8 The feed: likes, comments, Yap back `[V1.5]`
**What:** The dojo — an in-app social feed, built *after* solo retention is proven.

**Requirements:**
- Feed scopes: **friends-only first**; public/discovery is a later, gated expansion. Default post privacy stays private; sharing to the feed is an explicit choice per yap.
- Interactions: like, comment (text), and **Yap back** (record your own yap in response to someone's, linked as a thread/duet). Yap back is both engagement and a free practice rep.
- Follow/friend graph (contacts + handles).
- Feed framing/UX reinforces "everyone here is leveling up" (dojo, not stage) — e.g. surfacing improvement, not just polish.
- Simple ranking to start (recency + friends + light engagement); no heavy recommendation system pre-density.
- **Moderation from day one of the feed:** report/block/mute on yaps, comments, users; automated first-pass classification (LLM + heuristics) on transcripts/comments; rate limits on new accounts; community guidelines; review queue. Age-gating decision required (§13).

**AC:**
- A user can post a yap to the friends feed, and others can like, comment, and Yap back.
- Report/block/mute exist and function on launch of the feed.

### 7.9 Curated prompts & personalization `[MVP` basic, `V1.5` adaptive`]`
**What:** Prompts that feel like *you* and get more relevant over time.

**Requirements:**
- `[MVP]` New users get curated library prompts filtered by onboarding interests.
- `[V1.5]` Adaptive: blend in personalized prompts generated from interests + goal + weak-skill signals (e.g., more "explain simply" prompts if clarity lags) + past yap topics. Difficulty scales with performance.
- Prompt metadata: skill, theme, difficulty, target duration, optional structure hint, source (curated/personalized/challenge).

**AC:**
- Two users with different onboarding interests receive visibly different daily prompts.
- Over time, prompts reflect the user's demonstrated interests and skill gaps.

### 7.10 Content polish `[MVP` lite, `V1.5` full`]`
**What:** Turn a good yap's transcript into postable text, preserving the user's voice.

**Requirements:**
- `[MVP]` 1–2 formats (e.g., short caption + short-form script). Offered when a yap scores well.
- `[V1.5]` More formats (LinkedIn post, thread, newsletter blurb). "Keep it raw" light-cleanup option.
- Always editable before it leaves the app. Preserve the user's actual phrasing; don't ghost-write a different person.

**AC:**
- From a well-scored yap, user can generate an editable caption/script and export it.

### 7.11 Profile, highlight reel & skill trend `[MVP` basic, `V1.5` public`]`
**What:** The visible record of getting better — doubles as the personal-brand artifact.

**Requirements:**
- `[MVP]` Private profile: streak, total yaps, skill-trend dashboard (filler rate, pace, clarity, confidence as sparklines with deltas), personal records, per-yap history with replay + past feedback.
- `[V1.5]` Public profile page (shareable link): handle, bio, niche, curated **highlight reel** of best yaps, optional public stats. User controls exactly what's public.

**AC:**
- User can view their skill trends over time and replay past yaps with the original feedback.
- `[V1.5]` User can curate a highlight reel and share a public profile link, choosing what's visible.

### 7.12 Challenges `[V1.5]`
**What:** Themed, time-boxed prompts anyone can jump on — the competitive/viral/fun layer.

**Requirements:**
- Themed prompt with start/end window (e.g., "defend your most controversial food opinion in 30s").
- A mini-feed of participants' yaps; Yap-back and reactions; optional leaderboard.
- Authored by Yap team initially; later creators/coaches/orgs.

**AC:**
- A user can join an active challenge, record a yap to it, and see others' entries.

### 7.13 Monetization / Yap Pro `[V1.5]`
**What:** The paywall.

**Requirements:**
- Free: daily prompt + a capped number of yaps/day, core feedback (filler count, pace, basic tips), 1 export format, friends features.
- **Yap Pro:** unlimited yaps, full skill-trend analytics, all export/polish formats, adaptive personalized prompts, deep-dive reports (Opus-tier), priority processing. Billing via RevenueCat (iOS).
- `[Later]` Teams/B2B; creator/coach prompt-pack marketplace.

**AC:**
- Free limits enforced; Pro unlocks entitlements; purchase/restore works via App Store.

---

## 8. Prompt design (the provocation principle)

Prompts are the "host" of the show (Subway Takes inspiration). They must create tension the user wants to resolve, not invite a boring monologue.

- **Provocation-first:** hot takes to defend, spicy either/ors, "the hill you'll die on," story hooks ("the most embarrassing thing you did at work"). Avoid flat "describe X" prompts.
- **Speakable in ~60s:** narrow enough to answer in one breath of thought.
- **Tuned to interests:** a sports fan gets sports takes; a founder gets startup takes.
- **Yap-back-ready:** framed so someone can naturally disagree/respond, feeding the dojo.

Library is organized by **skill** (storytelling, hot-take/persuasion, explain-simply, thinking-on-your-feet, hooks) × **theme/interest**. Each with difficulty tiers.

---

## 9. AI / model specification

- **Transcription:** word-timestamped ASR (Deepgram / AssemblyAI / hosted Whisper). Word timestamps required for metrics.
- **Deterministic metrics:** computed in code from the transcript (no model).
- **Coaching + scripting + content polish:** **Claude**, structured JSON I/O, validated.
  - Default: **`claude-sonnet-5`** (quality/cost balance for per-yap analysis + Yapbot).
  - Cheap/high-volume paths (free tier quick feedback): **`claude-haiku-4-5-20251001`**.
  - Premium deep-dive reports (Pro): **`claude-opus-4-8`**.
  - *(Confirm current model IDs/pricing against Claude API docs at build time.)*
- **Moderation (feed):** LLM classifier + heuristics for first-pass; human review queue.
- **Prompt/response contracts:** every Claude call has a defined JSON schema (scores, tips[], highlight, structure_map), validated before display; graceful fallback if malformed.
- **Cost control:** deterministic metrics carry the free tier; Haiku for volume; cache where possible; cap free-tier yaps/day.

---

## 10. Data model (core entities)

```
User        id, handle, email, auth_provider, created_at
            profile: display_name, bio, niche, primary_goal, interests[], preferred_format
            settings: coach_harshness, default_privacy(=private), notif_time, notif_prefs

Prompt      id, text, skill, theme, difficulty, target_duration,
            structure_hint?, source(curated|personalized|challenge), author_id?, challenge_id?

Yap         id, user_id, prompt_id, media_ref, media_type, duration,
            transcript(json w/ word timestamps), privacy(private|friends|public),
            parent_yap_id?(yap-back), challenge_id?, created_at
            -> Analysis (1:1)

Analysis    id, yap_id, filler_count, filler_rate, wpm, pause_stats, ttr, repetition,
            yap_score, score_delta, clarity, confidence, hook_strength,
            structure_map(json), tips(json[]), highlight_line, model_used, created_at

ScriptDraft id, user_id, prompt_id, user_angle, scaffold(json), created_at   // Yapbot pre-record

ContentAsset id, yap_id, format, text, edited_by_user(bool), created_at

SkillTrendPoint id, user_id, yap_id, metric, value, created_at

Streak      user_id, current_len, longest_len, last_yap_date, freezes_available

Social      Follow(follower_id, followee_id), Like(user_id, yap_id),
            Comment(id, user_id, yap_id, text), DirectShare(id, from_user_id, to_user_id, yap_id)

Challenge   id, title, prompt_id, starts_at, ends_at, author_id, scope

Subscription user_id, tier(free|pro), status, renews_at, provider_ref

ModerationEvent id, target_type(yap|comment|user), target_id, reason, status, created_at
```

---

## 11. Technical stack (recommended)

- **Client:** iOS-first, **React Native + Expo** (or native Swift if the widget/camera experience demands it — decide in M0 spike). **WidgetKit** for the home-screen widget. Local-first capture, background resumable upload.
- **Backend:** **Node.js (TypeScript)** API + async **job queue** for the analysis pipeline (record/upload fast; transcription+LLM async). **Postgres** primary datastore.
- **Media:** **Mux** or **Cloudflare Stream** for video ingest/transcode/delivery/captions; object storage (S3/R2) for audio.
- **AI:** ASR provider (§9) + **Claude** (§9).
- **Cross-cutting:** Auth (Apple/Google/email), **RevenueCat** (subscriptions), product analytics (PostHog/Amplitude) from M0, push notifications, feature flags for milestone gating.

---

## 12. Release plan / milestones

Sequencing is strategic: **prove the solo loop retains before building the feed.**

### M0 — Spike & foundations (pre-MVP)
Repo/CI/envs, auth, app shell + widget skeleton, analytics instrumentation. **De-risking spike:** record → upload → transcribe → deterministic metrics → Claude feedback → render card, on one hardcoded prompt. Decide RN-vs-native based on widget/camera friction.

### M1 — Solo core loop `[MVP]`
Onboarding + un-scary first rep · daily prompt + iOS widget · Yapbot scripting + post-record coaching · record (audio/video) · scoring & delta coaching · streaks · private profile + skill trend · send-to-friends + export · basic curated prompts · lite content polish.
**No public feed.** **Exit gate:** hit agreed D7 / weekly-retained-yapper bar.

### M2 — Content & personalization depth
Full content-polish formats · adaptive personalized prompts + difficulty scaling · teleprompt overlay · richer profile.

### M3 — The dojo (social) `[V1.5]`
Friends feed · likes/comments/**Yap back** · follow graph · public profile + highlight reel · **moderation from day one** · challenges. Public discovery only after friends-feed density.

### M4 — Monetize & deepen
Yap Pro paywall + entitlements · deep-dive reports · full analytics.

### M5 — Expand
Acoustic/prosody analysis · direct multi-platform publishing · Android · teams/B2B · creator marketplace · secondary personas (interview/event mode).

---

## 13. Privacy, safety & moderation

- **Private by default.** No yap is visible to anyone without an explicit share. Every outbound/publish action is an explicit tap; nothing auto-posts.
- **Sensitive media:** yaps are personal recordings. Define retention, user-initiated deletion (hard delete), and export policy early. Clear stance on whether recordings are used for model training (default: no, or explicit opt-in).
- **Moderation** (from feed launch): report/block/mute; automated first-pass classification; review queue; rate limits on new accounts.
- **Age policy (decision required):** if under-18 allowed → age gating, restricted discovery, stricter moderation defaults.
- **Coach safety:** encouraging-by-default tone is a hard requirement; the harshness dial never overrides basic supportiveness for vulnerable/first-time users.

---

## 14. Risks & mitigations (carried from research)

| Risk | Mitigation |
|---|---|
| Camera shyness blocks activation | Un-scary first rep (§3.3); audio-first; private default. |
| Coaching feels generic or cruel | Delta-not-grade (§3.4); harshness dial; specific tips tied to the yap; praise-first. |
| "Practice vs. content" motivation conflict | Practice is the front door; content is unlocked as a reward (§3.1). |
| Feed = bad content / cold-start | Dojo framing (§3.2); friends-first; feed gated behind solo retention (§12). |
| Retention (category's chronic weakness) | Widget + streaks + visible improvement + daily provocation prompts. |
| Unit economics | Deterministic metrics carry free tier; Haiku for volume; caching; free-tier caps. |
| Yoodli/Speak move into this space | Ship the social+content fusion they lack; build network/content moat fast. |
| Trend-named brand ("Yap") ages with the trend | Accept as a known tradeoff; revisit brand at scale. |

---

## 15. Open questions to resolve in planning

1. **RN + Expo vs. native Swift** — decided by M0 spike (widget + camera + upload friction).
2. **Exact free-tier caps** — dependent on unit-economics modeling in M0.
3. **Under-18 policy** — gates moderation, discovery, and marketing.
4. **How "raw" content polish should be** — needs user testing to find the cleanup/ghost-write line.
5. **Notification cadence** — one daily nudge vs. smart timing; avoid feeling naggy.
6. **Video vs. audio default after onboarding** — likely audio-encouraged, video-optional; validate.
7. **Retention gate numbers** — set the specific D7 / weekly-retained-yapper bar that unlocks M3.

---

## 16. Summary

Yap is a daily habit that makes a specific, currently-underserved person — the aspiring yapper who freezes at the record button — good at talking to camera, and turns their reps into content and a visible record of improvement. The build is deliberately sequenced: nail the solo loop (widget → Yapbot → record → delta coaching → streak → send-to-friends) and prove it retains, *then* open the dojo, *then* monetize and expand. The four locked decisions — practice-front-door, dojo-not-stage, un-scary-first-rep, delta-not-grade — are what separate this from the joyless coaching utilities and the bad-content social apps it's competing against.
