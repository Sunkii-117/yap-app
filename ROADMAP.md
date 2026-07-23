# Yap — Master Roadmap

> **This is the source of truth for what we build and in what order.**
> Every working session starts by reading this file and the active milestone's detailed plan.
> The roadmap gives *milestone-level* goals with measurable "Definition of Done." Each milestone
> gets its own *task-level* plan in `docs/plans/` **before** we write code for it.

**Owner:** Founder · **Build lead:** Claude (SwiftUI, iOS-first)
**Last updated:** 2026-07-23
**Companion docs:** `yap-prd.md` · `yap-product-spec.md` · `yap-design-doc.md` · `yap-competitive-landscape.md` · `yap-spec-sheet.html`

Status legend: `⬜ not started` · `🟡 in progress` · `✅ done` · `⏸ parked (V1.5+)`

---

## 0. North star

**Yap is Couch-to-5K for talking to camera.** A daily prompt → shape a ~60s take with Yapbot →
record → get a score, filler count, and 2–3 delta-based tips → keep it private, send it, or post it.
Practice is the front door; content is the reward.

The visual system is **locked** (see `yap-spec-sheet.html`): *purple is the stage, gold is the reward*,
dark-only, Fraunces for headings/numbers, Nunito for UI, the candy button, the gold record mic.

### Locked product decisions (from PRD §3 — do not relitigate mid-build)
1. **Practice is the front door; content is the reward.** Posting is an *unlock*, not a starting mode.
2. **The feed is a dojo, not a stage.** Default privacy = private. (Feed is V1.5.)
3. **The first rep is engineered to be un-scary.** First yap: audio-only, ~15s, no score, permanently private.
4. **The coach tracks deltas, it does not grade.** Feedback compares you to your own recent yaps. No 1–10 verdicts.

---

## 1. Tech stack & global constraints

*Every milestone's plan implicitly inherits this section.*

- **Platform:** iOS 17.0+ (iPhone). iPad and macOS out of scope for v1.
- **Language/UI:** Swift 6, SwiftUI. No UIKit unless a control has no SwiftUI equivalent.
- **Project generation:** XcodeGen (`project.yml`) so the project is reproducible and diff-able. No hand-edited `.pbxproj`.
- **Widget:** WidgetKit extension sharing state with the app via **App Group** `group.com.yap.shared`.
- **Persistence:** SwiftData (iOS 17) for local yaps/metadata; audio/video files in the App Group container. Everything private by default; nothing leaves the device without an explicit user action.
- **AI/backend:** Coaching runs against the Claude API (`claude-opus-4-8` for quality-critical coaching; `claude-haiku-4-5` where latency matters). Transcription via on-device `Speech` framework first; revisit server-side if accuracy is short. **No API keys in the client** — coaching calls go through a thin backend proxy (stack TBD in S1/M3).
- **Design tokens:** `tokens.json` / `tokens.css` are the canonical values. The SwiftUI `YapColor`/`YapType`/etc. theme is generated to match them exactly and unit-tested against them.
- **Fonts:** Fraunces (Black/Bold/SemiBold) + Nunito (ExtraBold/SemiBold), bundled in-app (offline, consistent rendering) per design doc §11.
- **Accessibility floor (acceptance criteria, not polish — design doc §9):** WCAG AA contrast; color never the sole signal; Dynamic Type reflow; VoiceOver labels on every control; `prefers-reduced-motion`/Reduce Motion respected everywhere; tap targets ≥ 44pt.
- **Copy/voice:** warm, plain, a little cheeky, sentence case; actions say what happens; never grade, always nudge (design doc §8).

---

## 2. How we work (the operating rules — always stick to this)

1. **Roadmap first.** Start every session by reading `ROADMAP.md` + the active milestone plan. Do not free-solo.
2. **One milestone at a time.** Do not start M(n+1) until **every** Definition-of-Done checkbox in M(n) is ticked and demoed.
3. **Plan before code.** Each milestone gets a detailed task-level plan in `docs/plans/YYYY-MM-DD-mN-*.md` (writing-plans format: exact files, real code, TDD steps) **before** implementation.
4. **TDD + bite-sized tasks.** Failing test → minimal code → passing test → commit. Each task ends with an independently testable deliverable.
5. **Frequent commits, branch per milestone.** Work on `feat/mN-*`; never commit feature work straight to `main`. Open a PR and run `/review` (or `/code-review`) before merging.
6. **Evidence before "done."** A milestone is done only when its DoD is verified — tests green **and** the behavior demoed on a simulator/device (or, for logic, a passing `swift test`). No success claims without output.
7. **Update the Progress Log** (§6) at the end of each milestone: date, what shipped, what changed vs. plan.
8. **Scope discipline.** V1.5 items stay parked until v1 ships. When tempted to add, write it in §7 Parking Lot instead.
9. **De-risk early.** Spikes (throwaway experiments) validate the scariest assumptions before we commit to building on them. The coach-quality spike (S1) is the big one.
10. **Accessibility & reduced-motion are in every task's acceptance criteria**, not a cleanup pass at the end.

---

## 3. Milestone overview

| # | Milestone | Goal in one line | Status |
|---|-----------|------------------|--------|
| **S1** | Coach Quality Spike *(parallel, throwaway)* | Prove Claude can score + coach a yap usefully | ⬜ |
| **M0** | Foundation & Design System | Running app skeleton with the Yap theme in code, tested & on CI | ⬜ |
| **M1** | First Rep | Cold launch → un-scary 15s audio yap → Yapbot reaction, in < 2 min | ⬜ |
| **M2** | Today + iOS Widget | Daily prompt on home screen + a home-screen widget | ⬜ |
| **M3** | Coach Pipeline | Transcribe → score → filler count → 2–3 delta tips, productionized | ⬜ |
| **M4** | Record Studio + Score UI | The full studio record screen and the score/coaching reveal | ⬜ |
| **M5** | Yapbot Scripting | Chat → HOOK/MIDDLE/CLOSE scaffold card → "Record this" | ⬜ |
| **M6** | Streak, Progress, Profile | Streaks, Yap points, profile, highlight reel | ⬜ |
| **M7** | Content Unlock | Post / Save private / Send — the practice→content reward | ⬜ |
| **M8** | V1.5: Dojo + Pro | Friends feed + Yap Pro paywall | ⏸ |
| **M9** | Beta Hardening | A11y pass, perf, crash-free, TestFlight beta | ⬜ |

**Critical path to a demoable core loop:** M0 → M1 → M3 → M4. **Widget (your priority):** M2, unblocked right after M0/M1.
**S1 runs in parallel** and gates M3.

---

## 4. Milestones in detail

Each milestone lists **Goal · Why now · Scope · Deliverables · Definition of Done (measurable) · Dependencies · Plan**.
The DoD checkboxes are the contract — the milestone isn't finished until all are ticked.

---

### S1 · Coach Quality Spike (parallel, throwaway) ⬜
**Goal:** Prove the differentiator — that an LLM can turn a real recording into a *specific, kind, delta-aware*
coaching response — before we build any UI around it.
**Why now:** This is the single highest-uncertainty part of the product. If the coaching reads generic, the
whole thesis is at risk. Cheap to test, expensive to discover late.
**Scope (in):** A CLI/script: audio file → transcript (on-device `Speech` or a transcription API) → Claude
prompt producing `{score, filler_counts, pace_wpm, tips[2..3], highlight}` → printed output. A small eval set
of 8–10 real recordings. **Out:** any app UI, persistence, the delta-vs-last logic (mock "last yap" for now).
**Deliverables:** `spikes/coach/` script + prompt file + `EVAL.md` notes + 8–10 sample transcripts & outputs.
**Definition of Done:**
- [ ] Script runs end-to-end on a real audio file and prints structured coaching JSON.
- [ ] Founder rates output "specific & useful, not generic" on **≥ 8 of 10** samples.
- [ ] Filler-word counts are within ±1 of a hand count on all 10 samples.
- [ ] Coaching tips are forward-looking ("try…") and never a numeric verdict — 0 violations across samples.
- [ ] End-to-end latency documented; a target set for M3 (e.g. < 8s p50).
- [ ] Prompt + model choice + learnings written to `spikes/coach/EVAL.md`.
**Dependencies:** none. **Plan:** `docs/plans/2026-07-23-s1-coach-spike.md` *(written when we start S1)*.

---

### M0 · Foundation & Design System ⬜
**Goal:** A running SwiftUI app that launches into an in-app design-system gallery, with every Yap token in code
and unit-tested against `tokens.json`, on CI, committed and pushed.
**Why now:** Everything downstream is assembly of these components. Getting the theme + candy button right once
means every later screen is fast and on-brand.
**Scope (in):** XcodeGen project (app + widget stub + test targets), App Group, fonts, `YapColor/Gradient/Type/
Spacing/Radius/Shadow/Motion`, `CandyButton`, `YapCard`, a `DesignSystemGallery` root screen, CI.
**Out:** any product screens, persistence, networking.
**Deliverables:** buildable `Yap.xcodeproj` (generated), design-system source, tests, `.github/workflows/ci.yml`, README.
**Definition of Done:**
- [ ] `brew`-install prerequisites documented; `xcodegen generate` produces a project that builds clean.
- [ ] App launches on the iOS 17 simulator into `DesignSystemGallery`.
- [ ] Unit tests assert **every** color token's hex equals the value in `tokens.json` (all pass).
- [ ] Fraunces + Nunito load from the bundle (test: `UIFont(name:)` non-nil for each weight).
- [ ] `CandyButton` shows the press physics (translateY + edge shrink) and honors Reduce Motion.
- [ ] CI runs `xcodebuild test` green on push.
- [ ] Branch merged to `main` via PR after `/review`; roadmap Progress Log updated.
**Dependencies:** Xcode installed (see M0 plan Task 0). **Plan:** `docs/plans/2026-07-23-m0-foundation.md` ✅ *(written)*.

---

### M1 · First Rep ⬜
**Goal:** A first-time user goes from cold launch to a completed 15-second, audio-only, permanently-private yap
with a warm Yapbot reaction — in under 2 minutes, with no score shown.
**Why now:** This un-scary first rep is the product's wedge (PRD §3.3, §7.1). It's the smallest slice that
exercises the real record → store loop and the emotional bet.
**Scope (in):** Onboarding ("What do you want to get out of Yap?" cards → interest chips), the first-yap screen
("15 seconds. Audio only. Nobody sees this but you."), `AVAudioRecorder` capture with permission handling, the
record state machine, local persistence of the yap, Yapbot's "That's it. You just yapped." + reduced confetti.
**Out:** scoring, transcription, video, deltas, the full studio timer ring (that's M4).
**Deliverables:** onboarding + first-rep flow, `RecordingEngine`, SwiftData `Yap` model + store, unit tests.
**Definition of Done:**
- [ ] Fresh install → finish first yap in **< 2 min** (timed walkthrough recorded).
- [ ] Mic-permission denial path is handled with a calm, directive message (no dead end).
- [ ] The recording persists and survives an app relaunch; it is flagged private and audio-only.
- [ ] **No score, number, or grade** appears anywhere in this flow.
- [ ] Recording state machine unit-tested (idle→recording→stopped→saved; error paths).
- [ ] VoiceOver can complete the whole flow; Reduce Motion drops the confetti to a fade.
**Dependencies:** M0. **Plan:** *TBD when we start M1.*

---

### M2 · Today + iOS Widget ⬜  *(your near-term priority)*
**Goal:** The home tab shows today's prompt as a candy prompt-card with "Yap it" / "Help me script", and a
home-screen **WidgetKit widget** shows the same daily prompt and deep-links into the app.
**Why now:** The widget is the daily habit hook (PRD §1) and an explicit priority. It's small once M0's design
system and a prompt source exist.
**Scope (in):** `Today` screen, a `PromptProvider` (curated prompt list + "prompt of the day" selection by date),
App-Group-shared prompt store, `TodayWidget` in small/medium/large, `TimelineProvider` refreshing at local
midnight, deep link `yap://today`. **Out:** the actual recording from Today (routes into M1/M4 flow), scoring.
**Deliverables:** `Today` view, `PromptProvider`, shared store, widget extension, deep-link routing, tests.
**Definition of Done:**
- [ ] Today shows a deterministic "prompt of the day" (same prompt all day, changes at local midnight).
- [ ] Widget renders correctly in **all three** widget sizes (snapshot verified) with the brand purple + gold.
- [ ] Widget updates at local midnight and reflects the same prompt as the app (App Group verified).
- [ ] Tapping the widget deep-links into Today.
- [ ] `PromptProvider` date-selection logic unit-tested (stable within a day, advances across days, wraps the list).
- [ ] Widget respects Dynamic Type and dark rendering; VoiceOver reads the prompt.
**Dependencies:** M0 (design system, App Group). **Plan:** *TBD when we start M2.*

---

### M3 · Coach Pipeline ⬜
**Goal:** Productionize S1 into an app-callable service: given a recording, return `{score, fillers, pace,
tips, highlight}` measured as a **delta against the user's last yap**, behind a secure proxy.
**Why now:** Turns the validated spike into the real engine the score/coaching UI (M4) consumes.
**Scope (in):** on-device transcription, the backend proxy that holds the API key and calls Claude, the request/
response contract, the delta-vs-last-yap computation, error/timeout/offline handling ("saved on your phone").
**Out:** the score UI (M4), scripting (M5).
**Deliverables:** `CoachService` (client), proxy service, `CoachResult` model, delta logic, tests, contract doc.
**Definition of Done:**
- [ ] Given a recording, returns a valid `CoachResult` within the S1 latency target (p50).
- [ ] Deltas compare to the actual previous yap; first-ever scored yap has no delta (handled, not crashed).
- [ ] No API key ships in the client (verified — key lives only in the proxy).
- [ ] Offline/timeout returns a calm, retryable state; the recording is never lost.
- [ ] Delta + parsing logic unit-tested with fixture responses; malformed-LLM-output path handled.
**Dependencies:** S1, M1 (a stored yap to score). **Plan:** *TBD.*

---

### M4 · Record Studio + Score/Coaching UI ⬜
**Goal:** The full studio record screen (spotlight, gold mic, circular timer ring, audio⇄video toggle) and the
score reveal (88px Fraunces count-up in a gold ring, mint/coral delta chip, filler chips, ≤3 tip cards, highlight).
**Why now:** Completes the core loop the whole app is built around; consumes M3.
**Scope (in):** studio screen with spotlight-bloom entry + timer arc, the score screen with count-up + confetti on
milestones, filler chips → transcript jump, tip cards. **Out:** posting/sharing (M7).
**Deliverables:** `RecordStudioView`, `ScoreView`, count-up + ring components, transcript view, tests.
**Definition of Done:**
- [ ] Studio enters with the spotlight bloom; timer arc fills as you record; audio is the default mode.
- [ ] Score counts 0→final over ~900ms with the ring in sync; Reduce Motion shows the final value instantly.
- [ ] Delta chip shows ▲ mint / ▼ coral with the arrow glyph (meaning survives without color).
- [ ] Filler chips list caught fillers with counts; tapping one scrolls the transcript to that moment.
- [ ] At most 3 forward-looking tip cards; confetti only fires on a real milestone.
- [ ] Full screen passes VoiceOver + Dynamic Type + Reduce Motion checks.
**Dependencies:** M3, M0. **Plan:** *TBD.*

---

### M5 · Yapbot Scripting ⬜
**Goal:** A chat-style flow where the user gives their angle and Yapbot returns a HOOK / MIDDLE / CLOSE scaffold
card with "funnier / shorter / another angle" chips and a "Record this" gold CTA.
**Scope (in):** chat UI, scaffold-card generation via Claude, refine chips, hand-off into the studio with the
script pinned. **Out:** voice input polish (fast-follow).
**Definition of Done:**
- [ ] User's angle → a 3-beat scaffold card in one round trip; "Record this" carries the script into the studio.
- [ ] Each refine chip ("funnier"/"shorter"/"another angle") returns a changed scaffold.
- [ ] "Just record" escape hatch is always available (top-right).
- [ ] Generation + parsing unit-tested with fixtures; empty/short input handled.
**Dependencies:** M3 (Claude plumbing), M4 (studio hand-off). **Plan:** *TBD.*

---

### M6 · Streak, Progress, Profile, Highlight Reel ⬜
**Goal:** Daily streak (gold flame with lit/at-risk/freeze states), Yap points progress, and a private profile
with skill-trend sparklines and a highlight reel.
**Definition of Done:**
- [ ] Streak increments once per calendar day, shows at-risk and freeze states, and survives relaunch.
- [ ] Yap points accrue per rep with the chunky progress bar.
- [ ] Profile shows total yaps + streak as big gold Fraunces numbers and skill-trend sparklines with deltas.
- [ ] Highlight reel lists best yaps in xl-radius frames; everything private until explicitly shared.
- [ ] Streak date logic unit-tested across timezone/midnight edge cases.
**Dependencies:** M1, M3. **Plan:** *TBD.*

---

### M7 · Content Unlock (Post / Save / Send) ⬜
**Goal:** The reward moment — when a take is good, the "→ Post" gold CTA appears; the user can post, save private,
or send to a friend. "Post it" produces a "Posted." toast.
**Definition of Done:**
- [ ] The post CTA appears only when a yap clears the "ready" bar; default remains private.
- [ ] Post / Save private / Send each do exactly what they say; the button label matches the resulting toast.
- [ ] Share/export produces a correctly framed audio-waveform or video artifact.
- [ ] Sharing paths unit-tested (state transitions) and VoiceOver-labeled.
**Dependencies:** M4, M6. **Plan:** *TBD.*

---

### M8 · V1.5: Dojo Feed + Yap Pro ⏸ (parked)
Friends/Dojo feed (private-by-default, "everyone's leveling up") and the Yap Pro paywall (the one lavish gold
screen). **Parked until v1 ships.** Kept here so we don't forget the shape, not to build now.

---

### M9 · Beta Hardening ⬜
**Goal:** A crash-free, accessible, performant build in strangers' hands via TestFlight.
**Definition of Done:**
- [ ] Full accessibility audit passes (VoiceOver, Dynamic Type to XXL, contrast, Reduce Motion) on every shipped screen.
- [ ] Cold launch < 2s on a mid-tier device; record→score p50 within target.
- [ ] Crash-free sessions ≥ 99.5% across a week of internal use.
- [ ] TestFlight build distributed to ≥ 10 external testers; feedback triaged into the Parking Lot / next milestones.
**Dependencies:** M1–M7. **Plan:** *TBD.*

---

## 5. Risks & mitigations
- **Coach quality (highest).** → S1 spike gates M3; keep a human-tunable prompt and an eval set.
- **Xcode/toolchain not installed.** → M0 Task 0 installs it; blocks all iOS work until done.
- **Transcription accuracy for filler detection.** → start on-device `Speech`; S1 measures ±1 accuracy; fall back to a server transcriber if short.
- **API keys in a client app.** → non-negotiable proxy; no key ever ships client-side (M3 DoD).
- **Scope creep into V1.5.** → Parking Lot + rule §8; feed/Pro stay parked.
- **Fraunces variable-font weight names.** → M0 plan enumerates available font names at build time before asserting.

---

## 6. Progress log (append-only)
- **2026-07-23** — Direction locked: brand spec sheet + tokens (`yap-spec-sheet.html`, `tokens.css/json`) and the app-icon logo (`yap-logo-mockup.png`, watermark cleaned). Stack decided: **SwiftUI, iOS-first, widget prioritized.** Master roadmap + M0 plan written. Next: S1 spike and/or M0 Task 0 (install Xcode).

## 7. Parking lot (things we deliberately deferred)
- Video yaps beyond the toggle; audio-waveform visual spec.
- Yapbot mascot illustration (commission) + expressions/confetti pose.
- Public profile toggle; Friends/Dojo feed; Yap Pro paywall (M8).
- Light mode (design doc recommends dark-only at launch).
- Motion easing tokens; spotlight headline scrim token (from spec-sheet Gaps).
