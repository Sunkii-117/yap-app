# M3 · Coach Engine — Implementation Plan

> Productionizes the validated S1 spike into an app-callable engine. Founder decisions (2026-07-25): on-device Apple `Speech` transcription (behind a protocol), a thin **Node/TS** proxy holding the Anthropic key, coaching model `claude-opus-4-8`. Deterministic metrics live in a Swift twin — the LLM never counts.

**Goal:** Given a transcript (+ duration + the previous yap's metrics), return a validated `CoachResult { metrics, coaching, delta }` — filler/pace computed in Swift, and `{score, delta_note, tips[2..3], highlight}` from Claude via the proxy — with malformed-output and first-yap (no delta) handled.

**Architecture:** All Swift coach code in the app target under `Yap/Coach/`. Pure-logic pieces (metrics, delta, parsing, orchestration) are unit-tested with fixtures ported from the S1 samples (golden filler totals **s1=17, s2=6, s3=13**). Network + transcription sit behind protocols (`CoachBackend`, `Transcriber`) so tests inject mocks. The real backend is a thin Node/TS proxy (`proxy/`) that holds the key and calls Claude with the S1 `prompt.md`.

```
Yap/Coach/
  CoachMetrics.swift      # Swift twin of coachmetrics — filler lexicon + wpm (exact)
  CoachResult.swift       # CoachMetrics + CoachCoaching + MetricsDelta contract
  MetricsDelta.swift      # deterministic delta vs previous yap (nil on first yap)
  CoachingParser.swift    # strip fences / extract+decode+validate the LLM JSON
  CoachBackend.swift      # protocol: (prompt) async throws -> raw coaching JSON
  CoachService.swift      # orchestrates metrics -> prompt -> backend -> parse -> assemble
  Transcriber.swift       # protocol + Transcript; SpeechTranscriber (Apple Speech, file-based)
  CoachPrompt.swift       # prompt template (from spike prompt.md) + fill
proxy/                    # thin Node/TS Claude proxy (task 11)
YapTests/
  CoachFixtures.swift, CoachMetricsTests.swift, MetricsDeltaTests.swift,
  CoachingParserTests.swift, CoachServiceTests.swift
```

## Tasks (TDD)
- **A. `CoachMetrics`** — faithful Swift port of `coachmetrics`. Test: fixtures reproduce s1=17/s2=6/s3=13 fillers + wpm; empty/zero-duration edges. *(this commit)*
- **B. `CoachResult` + `MetricsDelta`** — contract + `delta(current:previous:)` returning `{fillersDelta, wpmDelta}` or nil when no previous. Test: delta math; first-yap nil.
- **C. `CoachingParser`** — decode `{score, delta_note, tips, highlight}`; strip ```json fences; validate (score 0–100, 2–3 tips, non-empty, no numeric-verdict words); throw on malformed. Test: clean JSON, fenced JSON, prose-wrapped, missing keys, out-of-range.
- **D. `CoachService` + `CoachBackend`** — orchestrate end to end with a mock backend returning fixture coaching JSON; assemble `CoachResult` with deltas; first-yap path. Test with fixtures.
- **E. `Transcriber` + `SpeechTranscriber`** — protocol + `Transcript`; real Apple `Speech` file recognizer (exercised in M1 when audio exists) + `MockTranscriber` for tests.
- **F. Proxy + HTTP backend** — Node/TS `POST /coach` holding the key, calling `claude-opus-4-8` with the prompt; `HTTPCoachBackend` client; runs locally, deploys when key+host provided. **No key in the client (verified).**

## DoD (mirrors ROADMAP M3)
- [ ] Given transcript+duration+prev, returns a valid `CoachResult` (fixtures).
- [ ] Deltas compare to the actual previous yap; first-ever yap has no delta (handled).
- [ ] No API key in the client (key only in the proxy).
- [ ] Malformed-LLM-output path handled (parser throws, service surfaces a retryable error).
- [ ] Delta + parsing unit-tested with fixtures.
- [ ] Latency target < 8s p50 documented (from S1) — measured once the proxy has a key.
