# S1 · Coach Quality Spike — Plan (throwaway)

> Throwaway spike to de-risk the product's biggest unknown: can we turn a real yap into *specific, kind,
> delta-aware* coaching? This code is disposable — its job is to produce evidence, not to be productionized.
> The learnings (prompt, model, architecture) graduate into M3.

**Goal:** Given a transcript (+ duration + the previous yap's metrics), emit a `CoachResult`
(`{score, delta_note, tips[2..3], highlight}` + objective metrics) and judge whether the coaching is good.

**Key architectural bet (the thing we're proving is even the right shape):**
Split the work. **Objective metrics — filler counts, WPM — are computed deterministically in code** (a Swift
tool), never by the LLM (LLMs miscount). The LLM only does the judgment part: score, deltas, forward-looking
tips, and picking the line that landed. This is also what M3 will do.

**How it runs now (no Xcode, no API key):** metrics via a SwiftPM executable (`swift` CLI); coaching via the
`claude -p` headless CLI (uses existing Claude Code auth). Transcription is deliberately **out of scope** — we
feed hand-written transcripts, since transcription accuracy is a separate risk tracked for M3.

## Files
```
spikes/coach/
├── Package.swift
├── Sources/coachmetrics/main.swift   # transcript+duration → {word_count,wpm,fillers,fillers_total}
├── prompt.md                         # the coaching prompt (strict JSON out)
├── run.sh                            # metrics → prompt → claude -p → merged CoachResult
├── samples/s1.json … s3.json         # transcript + duration + previous-yap metrics
└── EVAL.md                           # how to run + the rating table (founder fills)
```

## Tasks
- [ ] **T1:** Swift metrics tool (`coachmetrics`): reads transcript on stdin, `--duration <sec>`, prints metrics JSON.
- [ ] **T2:** `prompt.md` — Yapbot coaching prompt; forward-looking, delta-aware, JSON-only output.
- [ ] **T3:** 3 realistic sample yaps with mocked previous-yap metrics (one improved, one mixed, one improved).
- [ ] **T4:** `run.sh` — glue: build tool, compute metrics, fill prompt, call `claude -p`, merge to `CoachResult`.
- [ ] **T5:** Run all samples; capture outputs; founder rates in `EVAL.md`.

## Definition of Done (from ROADMAP.md · S1)
- [ ] Runs end-to-end on a sample and prints structured coaching JSON.
- [ ] Founder rates output "specific & useful, not generic" on **≥ 8 of 10** samples.
- [ ] Filler counts within **±1** of a hand count on all samples.
- [ ] Tips forward-looking, never a numeric verdict — **0** violations.
- [ ] Latency documented; a target set for M3.
- [ ] Prompt + model + learnings written to `EVAL.md`.

## Run
```bash
cd spikes/coach
./run.sh samples/s1.json
```
