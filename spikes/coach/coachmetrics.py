#!/usr/bin/env python3
"""coachmetrics — deterministic yap metrics (spike-runnable Python twin of Sources/coachmetrics/main.swift).

Usage: printf '<transcript>' | python3 coachmetrics.py --duration <seconds>
Emits JSON: { word_count, duration_sec, wpm, fillers: {word: count}, fillers_total }

The Swift version in Sources/ is the reference that graduates to M3; this Python twin exists
only because the Command Line Tools Swift toolchain can't compile against this machine's SDK yet.
Keep the two in sync.
"""
import sys, re, json

duration = 60.0
args = sys.argv[1:]
i = 0
while i < len(args):
    if args[i] == "--duration" and i + 1 < len(args):
        try:
            duration = float(args[i + 1])
        except ValueError:
            duration = 60.0
        i += 2
    else:
        i += 1

transcript = sys.stdin.read()
lower = transcript.lower()

# word count: runs of letters/apostrophes
word_count = len(re.findall(r"[a-z']+", lower))

# Filler lexicon — same set as the Swift tool. "so"/"right"/"well" as legit words are excluded
# (only "right," with a trailing comma is treated as a filler) to protect the +/-1 accuracy target.
fillers = [
    "um", "uh", "er", "ah", "hmm",
    "like", "you know", "i mean", "actually", "basically",
    "literally", "kinda", "kind of", "sort of", "right,",
]

counts = {}
for f in fillers:
    esc = re.escape(f)
    pat = esc if f.endswith(",") else r"\b" + esc + r"\b"
    c = len(re.findall(pat, lower))
    if c > 0:
        key = "right" if f == "right," else f
        counts[key] = c

fillers_total = sum(counts.values())
wpm = round(word_count / (duration / 60.0)) if duration > 0 else 0

out = {
    "word_count": word_count,
    "duration_sec": duration,
    "wpm": wpm,
    "fillers": dict(sorted(counts.items())),
    "fillers_total": fillers_total,
}
print(json.dumps(out, indent=2, sort_keys=True))
