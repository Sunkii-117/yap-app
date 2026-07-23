#!/usr/bin/env bash
# S1 coach spike runner: sample -> deterministic metrics -> LLM coaching -> merged CoachResult.
set -euo pipefail

SAMPLE="${1:?usage: ./run.sh samples/s1.json}"
DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"

# 1. Pull the sample fields.
transcript=$(jq -r '.transcript' "$SAMPLE")
duration=$(jq -r '.duration_sec' "$SAMPLE")
prev_wpm=$(jq -r '.prev.wpm // "n/a"' "$SAMPLE")
prev_fillers=$(jq -r '.prev.fillers_total // "n/a"' "$SAMPLE")

# 2. Deterministic metrics (NOT the LLM). Python twin of the Swift tool (see coachmetrics.py header).
metrics=$(printf '%s' "$transcript" | python3 coachmetrics.py --duration "$duration")

# 4. Fill the coaching prompt.
prompt=$(cat prompt.md)
prompt=${prompt//'{{TRANSCRIPT}}'/$transcript}
prompt=${prompt//'{{METRICS}}'/$metrics}
prompt=${prompt//'{{PREV}}'/wpm=$prev_wpm, fillers_total=$prev_fillers}

# 5. LLM coaching via headless Claude Code (no API key needed). Time it.
echo "calling claude -p…" >&2
start=$(date +%s)
coaching=$(printf '%s' "$prompt" | claude -p 2>/dev/null | sed '/^```/d')
end=$(date +%s)
latency=$(( end - start ))

# 6. Merge deterministic metrics + LLM coaching into one CoachResult.
if printf '%s' "$coaching" | jq empty >/dev/null 2>&1; then
  jq -n \
    --arg id "$(jq -r '.id' "$SAMPLE")" \
    --arg prompt "$(jq -r '.prompt' "$SAMPLE")" \
    --argjson latency "$latency" \
    --argjson metrics "$metrics" \
    --argjson coaching "$coaching" \
    '{sample:$id, yap_prompt:$prompt, latency_sec:$latency, metrics:$metrics, coaching:$coaching}'
else
  echo "!! coaching was not valid JSON — raw model output below:" >&2
  printf '%s\n' "$coaching"
  exit 1
fi
