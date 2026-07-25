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
3. **Onboarding is a normal first-run flow; the first yap is a real yap.** Auth → capture goal + interests + default format, then into the standard loop (prompt → optional Yapbot → record → coach with score + delta tips). No forced "15s, audio-only, no-score" first rep. *(Reshaped 2026-07-25 by founder; supersedes PRD §3 #3.)*
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
| **M0** | Foundation & Design System | Running app skeleton with the Yap theme in code, tested & on CI | ✅ |
| **M1** | Onboarding + First Rep | Normal onboarding → a real first yap (UI first pass 🟡) | 🟡 |
| **M2** | Today + iOS Widget | Daily prompt on home screen + a home-screen widget | 🟡 |
| **M3** | Coach Pipeline | Transcribe → score → filler count → 2–3 delta tips, productionized | 🟡 |
| **M4** | Record Studio + Score UI | The full studio record screen and the score/coaching reveal (UI first pass 🟡) | 🟡 |
| **M5** | Yapbot Scripting | Chat → HOOK/MIDDLE/CLOSE scaffold card → "Record this" | ⬜ |
| **M6** | Streak, Progress, Profile | Streaks, Yap points, profile, highlight reel | ⬜ |
| **M7** | Content Unlock | Post / Save private / Send — the practice→content reward | ⬜ |
| **M8** | V1.5: Dojo + Pro | Friends feed + Yap Pro paywall | ⏸ |
| **M9** | Beta Hardening | A11y pass, perf, crash-free, TestFlight beta | ⬜ |

**Build order (reprioritized 2026-07-25):** M0 ✅ → **now: M2 widget + M3 coach engine** (logic/backend, no design) → then the frontend phase: M1 (onboarding + record) → M4 (score UI).
*Rationale:* founder direction — build the widget and the AI coaching engine first; frontend + visual design come after. **S1 ✅** fed M3.

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

### M0 · Foundation & Design System ✅
**Goal:** A running SwiftUI app that launches into an in-app design-system gallery, with every Yap token in code
and unit-tested against `tokens.json`, on CI, committed and pushed.
**Why now:** Everything downstream is assembly of these components. Getting the theme + candy button right once
means every later screen is fast and on-brand.
**Scope (in):** XcodeGen project (app + widget stub + test targets), App Group, fonts, `YapColor/Gradient/Type/
Spacing/Radius/Shadow/Motion`, `CandyButton`, `YapCard`, a `DesignSystemGallery` root screen, CI.
**Out:** any product screens, persistence, networking.
**Deliverables:** buildable `Yap.xcodeproj` (generated), design-system source, tests, `.github/workflows/ci.yml`, README.
**Definition of Done:**
- [x] `brew`-install prerequisites documented; `xcodegen generate` produces a project that builds clean.
- [x] App launches on the iOS 17 simulator into `DesignSystemGallery`. *(verified on iPhone 17 / iOS 26.5 sim — screenshot)*
- [x] Unit tests assert **every** color token's hex equals the value in `tokens.json` (all pass). *(15-token guard, green)*
- [x] Fraunces + Nunito load from the bundle (test: `UIFont(name:)` non-nil for each weight). *(3 font tests green)*
- [x] `CandyButton` shows the press physics (translateY + edge shrink) and honors Reduce Motion.
- [x] CI runs `xcodebuild test` green on push. *(both runs pass — 2m49s / 3m47s on macos-15)*
- [x] Branch merged to `main` via PR after `/review`; roadmap Progress Log updated. *(PR #1 squash-merged; /review clean, 0 findings)*
**Dependencies:** Xcode installed (see M0 plan Task 0). **Plan:** `docs/plans/2026-07-23-m0-foundation.md` ✅ *(written)*.

---

### M1 · Onboarding + First Rep ⬜ *(frontend — deferred; build after M2 widget + M3 coach engine)*
**Goal:** A first-time user signs in, tells us a little about themselves, and completes a **real** first yap —
prompt → (optional Yapbot) → record → coach — with no artificial limits.
**Why now:** Onboarding + the record→store loop is the spine of the app. **Reprioritized (2026-07-25):** the
visual build waits behind the widget (M2) and the coach engine (M3) per founder direction — logic/backend now,
frontend later.
**Scope (in) — "all the things" for first run:**
- **Auth:** Sign in with Apple + Google + email.
- **Profile capture:** primary goal (start posting / get more confident / just curious), 3–5 interest tags
  (picker or free text), preferred default format (audio/video).
- **First yap = a normal yap:** land in the core loop — prompt → optional Yapbot scripting → `AVAudioRecorder` /
  `AVCaptureSession` capture with permission handling → scored by the coach (M3) with delta tips.
- Record state machine; local SwiftData persistence; **private by default**.
**Out:** the full studio timer-ring + score-reveal UI (M4); the coach engine itself (M3); video polish.
**Deliverables:** onboarding flow, `RecordingEngine`, SwiftData `Yap` model + store, unit tests.
**Definition of Done:**
- [ ] Fresh install → auth → profile capture → first completed yap, with no dead ends.
- [ ] Auth works for Apple + Google + email; profile (goal, interests, format) persists across relaunch.
- [ ] Mic/camera-permission denial paths handled with calm, directive copy (no dead end).
- [ ] The recording persists and survives relaunch; private by default.
- [ ] Interests captured in onboarding measurably influence the first curated prompt.
- [ ] Record state machine unit-tested (idle→recording→stopped→saved; error paths).
- [ ] VoiceOver can complete the flow; Reduce Motion respected.
**Dependencies:** M0; coach engine (M3) to score the first yap. **Plan:** *TBD when we build M1 (frontend phase).*

---

### M2 · Today + iOS Widget 🟡  *(logic done + tested; widget visuals deferred to design phase)*
**Goal:** The home tab shows today's prompt as a candy prompt-card with "Yap it" / "Help me script", and a
home-screen **WidgetKit widget** shows the same daily prompt and deep-links into the app.
**Why now:** The widget is the daily habit hook (PRD §1) and an explicit priority. It's small once M0's design
system and a prompt source exist.
**Scope (in):** `Today` screen, a `PromptProvider` (curated prompt list + "prompt of the day" selection by date),
App-Group-shared prompt store, `TodayWidget` in small/medium/large, `TimelineProvider` refreshing at local
midnight, deep link `yap://today`. **Out:** the actual recording from Today (routes into M1/M4 flow), scoring.
**Deliverables:** `Today` view, `PromptProvider`, shared store, widget extension, deep-link routing, tests.
**Definition of Done:**
- [x] Today shows a deterministic "prompt of the day" (same prompt all day, changes at local midnight). *(PromptProvider unit-tested; Today verified on sim.)*
- [~] Widget renders correctly in **all three** widget sizes (snapshot verified) with the brand purple + gold. *(3 families + brand colors coded & bundled; on-device widget snapshot pending Xcode preview — CLI can't place widgets.)*
- [x] Widget updates at local midnight and reflects the same prompt as the app (App Group verified). *(timeline policy `.after(nextMidnight)`; shared `PromptProvider`/`SharedStore`, round-trip tested.)*
- [~] Tapping the widget deep-links into Today. *(`.widgetURL(yap://today)` + app `.onOpenURL` + Today root wired; on-device tap pending a placed widget.)*
- [x] `PromptProvider` date-selection logic unit-tested (stable within a day, advances across days, wraps the list). *(4 tests green.)*
- [~] Widget respects Dynamic Type and dark rendering; VoiceOver reads the prompt. *(dark ✓, VoiceOver label ✓; Dynamic Type via `minimumScaleFactor` — full reflow pass in the design phase.)*
**Dependencies:** M0 (design system, App Group). **Plan:** `docs/plans/2026-07-25-m2-widget.md` ✅.
> *Legend:* `[~]` = code-complete, on-device widget visual/interaction verification deferred to the design phase (founder deferred frontend/design 2026-07-25).

---

### M3 · Coach Pipeline 🟡 *(engine built + tested; end-to-end recording→coach pending M1 record flow + deployed key)*
**Goal:** Productionize S1 into an app-callable service: given a recording, return `{score, fillers, pace,
tips, highlight}` measured as a **delta against the user's last yap**, behind a secure proxy.
**Why now:** Turns the validated spike into the real engine the score/coaching UI (M4) consumes.
**Scope (in):** on-device transcription, the backend proxy that holds the API key and calls Claude, the request/
response contract, the delta-vs-last-yap computation, error/timeout/offline handling ("saved on your phone").
**Decisions (2026-07-25):** transcription = **on-device Apple `Speech`** (behind a `Transcriber` protocol so a cloud ASR can drop in later); proxy = **thin Node/TS service** holding the Anthropic key (runnable locally; deploy when key + host provided); coaching model = **`claude-opus-4-8`** (quality-critical), revisit Haiku/Sonnet for cost. Deterministic metrics live in a **Swift twin** of `coachmetrics` — the LLM never counts.
**Out:** the score UI (M4), scripting (M5).
**Deliverables:** `CoachService` (client), proxy service, `CoachResult` model, delta logic, tests, contract doc.
**Definition of Done:**
- [~] Given a recording, returns a valid `CoachResult` within the S1 latency target (p50). *(`CoachService`: transcript+metrics → prompt → proxy → parsed `CoachResult`, fixture-tested. Recording→transcript (Speech) seam built; end-to-end latency measured once the proxy has a key + the M1 record flow exists.)*
- [x] Deltas compare to the actual previous yap; first-ever scored yap has no delta (handled, not crashed). *(`MetricsDelta` + `CoachServiceTests`.)*
- [x] No API key ships in the client (verified — key lives only in the proxy). *(`HTTPCoachBackend` holds only the URL; key is `ANTHROPIC_API_KEY` in the proxy.)*
- [~] Offline/timeout returns a calm, retryable state; the recording is never lost. *(Backend/service surface errors as thrown errors; the calm retryable UI + local persistence land with M1/M4.)*
- [x] Delta + parsing logic unit-tested with fixture responses; malformed-LLM-output path handled. *(`CoachingParserTests` + `CoachServiceTests` — 12 coach tests.)*
**Dependencies:** S1, M1 (a stored yap to score). **Plan:** `docs/plans/2026-07-25-m3-coach-engine.md` ✅.
> *Legend:* `[~]` = engine complete + tested; the end-to-end path (real audio → on-device transcription → deployed proxy → latency, plus the offline/retry UI) lands with the M1 record flow and a deployed Anthropic key.

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
- **2026-07-24** — **M0 shipped ✅ — merged to `main` via PR #1** (squash; CI green, `/review` clean with 0 findings). XcodeGen project (app + widget stub + tests), all Yap tokens in code, `CandyButton`, `YapCard`, and the `DesignSystemGallery` app root. 5 unit tests green (hex, 15-token color guard vs `tokens.json`, 3 font-registration); gallery verified rendering on the iPhone 17 / iOS 26.5 simulator. *Deltas vs plan:* (1) machine has **Xcode 26.6 / iOS 26.5 sim only** — no `iPhone 15`, so the destination is **`iPhone 17`** (Makefile) and CI picks an available device dynamically; (2) the plan's minimal `Info.plist` lacked `CFBundleIdentifier` → simulator install failed with "Missing bundle ID", fixed by adding standard `CFBundle*` keys wired to build settings; (3) google-webfonts-helper statics ship **mangled name tables** (Nunito reported as "Nunito ExtraLight ExtraBold") → normalized to clean family + PostScript names with fontTools; (4) XcodeGen flattens resources, so `UIAppFonts` uses **bundle-root filenames**, not `Fonts/…`. Next: CI green → `/review` → merge → start M1 (or M2 widget, the near-term priority).
- **2026-07-25** — **Frontend v1 built (🟡) on `feat/frontend-v1`** *(founder un-parked the frontend).* Simple SwiftUI first pass of the whole core loop, to the locked design doc (purple stage / gold reward, Fraunces + Nunito, candy button), via the `ui-ux-pro-max` skill: **Onboarding** (Yapbot orb, goal cards, interest chips), **Today** (streak, prompt-of-day card, Yap it / Help me script, week strip), **Record studio** (spotlight gradient, gold mic + timer arc, audio/video toggle — capture mocked), **Score** (count-up dial in a gold ring, mint delta chip, real filler chips + tips from `DemoCoachResult`, highlight, post/save/send), **Profile** (gold stat tiles, skill-trend rows). Reusable bits: `YapbotOrb`, `RingProgress`, `YapChip`/`SelectableChip`/`DeltaChip`, `StreakFlame`, `Eyebrow`, `FlowLayout`; a `#if DEBUG` screen router for screenshots. App root is now `RootView` (onboarding gate + tab shell). All 5 screens verified on the iPhone 17 sim; 29 tests still green. Spans **M1** (onboarding/record UI) + **M4** (score UI) — visual first pass; the real record engine, persistence, and live coach are still pending (coach needs a deployed proxy + active billing — key provided but payment failing). *Deferred hooks:* Yapbot scripting (M5), the 5-tab bar with center Record FAB, mascot illustration, confetti/win screen.
- **2026-07-25** — **Record engine + persistence + tab bar + win polish (autonomous session).** Real capture: `RecordingEngine` (mic permission via `AVAudioApplication`, `AVAudioRecorder` → `.m4a`), `RecordStateMachine` (pure, **4 unit tests**), on-device `Speech` transcription wired through `CoachRunner` (→ exact metrics → live coach if `yap.proxyURL` is set, else a metric-derived placeholder; empty audio → demo sample). **SwiftData** `YapRecord` model + persistence on finish; delta uses the real previous yap; Profile total via `@Query`. Full loop: Record → "Coach is listening…" → Score → **Win** (gold-foil `ConfettiView`, reduce-motion aware) on milestones. **5-tab bar** (Today/Coach/Record FAB/Friends/Profile; Coach+Friends placeholders). Mic-denied → calm Settings screen. Fixed a recorder/session leak on cancel. **33 tests green**; all screens verified on iPhone 17. **M1** now has a working record→persist loop (state machine, permission, SwiftData) and **M4** a real record+score UI. *Needs founder (noted, skipped):* (1) **Auth** — Sign in with Apple/Google/email needs your Apple Developer account + capabilities/OAuth setup; (2) **deploy the proxy + active billing** for the live coach (then just set `yap.proxyURL`); (3) **rotate the API key** you pasted in chat; (4) **real-device mic/Speech test** (the sim can't truly record speech). *Still to build:* interest-based prompt personalization, transcript persistence for replay, video capture, streak date-logic (currently increments per yap).
- **2026-07-25** — **Plan reshaped by founder + build reprioritized.** Dropped the "15s, audio-only, no-score un-scary first rep" (was PRD §3 #3 / §7.1 / M1) — it wasn't the founder's intent. **M1 is now "Onboarding + First Rep":** normal auth (Apple/Google/email) + profile capture (goal, interests, format) → a *normal* first yap. **Build order flipped:** do **M2 widget + M3 coach engine** now (logic/backend), frontend + design later. **Decisions locked:** transcription = on-device Apple `Speech` (behind a `Transcriber` protocol); coach proxy = thin **Node/TS** service holding the Anthropic key; coaching model = `claude-opus-4-8`. Also corrected the stale **RN+Expo** stack note in PRD §11 → the native SwiftUI reality we actually shipped in M0. Next: M2 widget plan + build, then coach engine + proxy.
- **2026-07-25** — **M2 widget logic built (🟡) on `feat/m2-widget`.** Shared core compiled into app + widget: `Prompt`, curated `PromptLibrary` (14 provocation-first prompts), deterministic `PromptProvider` (prompt-of-the-day by local day — stable/advances/wraps, 4 tests), `SharedStore` over the App Group (3 tests). Real `TodayWidget` (small/medium/large, brand purple+gold, midnight-refresh timeline, `yap://today` deep link) + a minimal functional `TodayView` landing screen; the app publishes today's prompt to the App Group + reloads the widget on launch. **12 unit tests green**; Today verified rendering on the sim. *Deferred (founder — frontend/design later):* on-device widget visual snapshot + tap-through (CLI can't place widgets), custom-font-in-widget, full Dynamic Type reflow. Next: coach engine + thin proxy.
- **2026-07-25** — **M3 coach engine built (🟡) on `feat/m3-coach`.** Productionized S1 into Swift: `CoachMetrics` (twin of `coachmetrics` — reproduces the validated s1=17/s2=6/s3=13 filler baseline exactly), `CoachResult`/`CoachCoaching` contract (snake_case, matches the S1 prompt input), `MetricsDelta` (signed deltas; nil on first yap), `CoachingParser` (strips fences/prose, validates, throws on malformed), `CoachService` (metrics→prompt→backend→parse→assemble), `CoachPrompt` (verbatim S1 template), `Transcriber` protocol + on-device `SpeechTranscriber`, and `HTTPCoachBackend`. Plus a **thin Node/TS proxy** (`proxy/`) holding `ANTHROPIC_API_KEY`, `POST /coach` → `claude-opus-4-8` → text; typechecks, boots, `/health` + validation verified (no key in client — `HTTPCoachBackend` knows only the URL). **12 coach unit tests green** (metrics baseline, delta, parser incl. malformed, end-to-end via mock backend, first-yap no-delta, backend stub). *Pending:* real audio → transcription → **deployed proxy** latency, and the offline/retry UI — both land with the M1 record flow + a deployed Anthropic key. Next: `/review` → merge; then M1 (frontend) or wire the proxy once you provide a key.

## 7. Parking lot (things we deliberately deferred)
- Video yaps beyond the toggle; audio-waveform visual spec.
- Yapbot mascot illustration (commission) + expressions/confetti pose.
- Public profile toggle; Friends/Dojo feed; Yap Pro paywall (M8).
- Light mode (design doc recommends dark-only at launch).
- Motion easing tokens; spotlight headline scrim token (from spec-sheet Gaps).
- **Coach proxy deploy-hardening** (from M3 `/review`, do before exposing the proxy publicly): add an app-token/auth check + rate limiting to `POST /coach`; explicit refusal/empty-content handling in the proxy; an optional request timeout on `HTTPCoachBackend`.
