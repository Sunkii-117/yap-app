# S1 · Coach Spike — Evaluation

**Question we're answering:** Can we turn a yap into coaching that feels *specific, kind, and delta-aware* —
not generic? If yes, the product's core bet holds and we productionize this in M3.

## Architecture proven here
- **Objective metrics are deterministic** (`coachmetrics`, Swift): filler counts + WPM computed by code, so
  they're exact and cheap — the LLM never counts.
- **The LLM does judgment only** (`claude -p`): score, delta note, 2–3 forward-looking tips tied to the actual
  transcript, and the line that landed. Model: whatever the local Claude Code session uses (Opus 4.8 default).
- **Transcription is out of scope** (separate M3 risk) — we feed hand-written transcripts.

## How to run
```bash
cd spikes/coach
./run.sh samples/s1.json      # or s2, s3
```
Output is one merged `CoachResult` JSON: `{sample, yap_prompt, latency_sec, metrics, coaching}`.

## Definition of Done (mirrors ROADMAP.md · S1)
- [x] Runs end-to-end and prints structured coaching JSON. *(all 3 samples, 2026-07-23)*
- [ ] Founder rates output "specific & useful, not generic" on **≥ 8 of 10** samples. *(← needs your sign-off; 3/3 look strong)*
- [x] Filler counts within **±1** of a hand count on every sample. *(exact — 0 error on s1=17, s2=6, s3=13)*
- [x] Tips forward-looking, **0** numeric-verdict violations. *(9/9 tips start with a verb; no grades)*
- [x] Latency documented + M3 target set. *(7–9s observed; target < 8s p50)*
- [x] Prompt + model + learnings captured here.

## Rating table
Objective columns filled from the 2026-07-23 run; **"Specific & useful" is yours to judge** (my read in parens).
| Sample | Specific & useful? | Fillers within ±1? | No grade/verdict? | Latency (s) | Notes |
|--------|--------------------|--------------------|-------------------|-------------|-------|
| s1     | _(looks y)_        | y (exact, 17)      | y                 | 7           | Quoted "scared of a little bit of joy"; tied tips to salty/savory/sweet trio + DMV line. |
| s2     | _(looks y)_        | y (exact, 6)       | y                 | 9           | Caught the "receipt" metaphor; suggested repeating it as a frame. |
| s3     | _(looks y)_        | y (exact, 13)      | y                 | 7           | Flagged "forty step skincare" as the funniest line; pushed to cut softeners. |

> Next: rate these, then grow the set toward 8/10 — ideally from **real recordings** once we have transcription.

## Latency target for M3
- Observed (CLI headless `claude -p`, warm auth): **7–9s** per yap (metrics are instant; ~all of it is the model).
- Proposed M3 target: **< 8s p50** end-to-end (on-device transcribe + coach); the score UI can reveal progressively so it *feels* faster.

## Learnings / decisions
- **The split works.** Deterministic metrics (exact filler/wpm) + LLM-judgment-only is the right shape — the model never had to count, and it leaned on the given numbers for accurate deltas. Carry this into M3.
- **Coaching is specific, not generic.** Every tip referenced a real phrase from the transcript; the highlight quoted the actual best line. That's the whole product bet, and it held on 3/3.
- **Voice held.** No grades/verdicts appeared; tips were forward-looking verbs. The prompt's "never grade" rule was obeyed without extra coaxing.
- **Deltas need a real "last yap."** Here it's mocked in each sample; M3 must pull the actual previous yap's metrics and handle the first-ever-scored case (no delta).
- **Open for M3:** transcription accuracy (the biggest untested piece — fillers depend on it), the score formula (currently the LLM's judgment call — decide if it should be a deterministic function of metrics + LLM tone), and moving the metrics logic into the Swift twin behind a proxy that holds the API key.
