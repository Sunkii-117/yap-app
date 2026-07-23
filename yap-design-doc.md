# Yap — Design Doc (Visual System & UI)

**Version:** 1.0
**Status:** Design direction locked, ready for hi-fi mockups / build
**Companion docs:** `yap-prd.md`, `yap-product-spec.md`, `yap-competitive-landscape.md`
**Last updated:** 2026-07-22

---

## 0. The core idea (why it looks the way it looks)

Every visual choice ladders up to one concept, taken straight from the two reference images:

> **Purple is the stage. Gold is the reward.**

The purple radial gradient reads as a **lit photography studio backdrop** — a spotlight on a seamless. That's exactly what Yap is emotionally: you *step onto the stage* and talk to camera. Deep purple is the room; the brighter purple bloom is the spotlight you stand in. **Gold** (foil, warm, precious) is reserved for the things you *earn* — your score going up, your streak, "ready to post," Yap Pro. Gold is never wallpaper; it's a prize. Keeping that separation strict is what keeps the app from looking like a generic purple SaaS product.

The personality is **Duolingo-chunky meets editorial-serif**: big pressable candy buttons, satisfying wins, a friendly mascot — but with **Fraunces**, a characterful display serif, carrying every headline and every big number. That serif-on-a-game-UI pairing is the signature no competitor (Yoodli, Speak, BeReal) has.

---

## 1. Color system

All values are tokens. Never hardcode hex in components — reference the token.

### 1.1 Purple — "Studio" (primary)
| Token | Hex | Use |
|---|---|---|
| `studio-ink` | `#180530` | Deepest background base, app background |
| `studio-grape` | `#2C0A56` | Cards / raised surfaces on dark |
| `studio-royal` | `#4A159C` | Secondary surfaces, pressed states |
| `studio-violet` | `#7C2BE0` | **Primary brand** — buttons, active states, brand fills |
| `studio-orchid` | `#A64BF4` | Spotlight center, highlights, focus glow |
| `studio-lilac` | `#C9A6F0` | Muted text on dark, inactive icons, hairlines |

### 1.2 Gold — "Foil" (secondary / reward)
| Token | Hex | Use |
|---|---|---|
| `foil-amber` | `#E8A317` | Deep edge of gold gradient, gold button bottom-edge |
| `foil-gold` | `#F6C324` | **Reward primary** — streak, score-up, primary gold CTA |
| `foil-sun` | `#FFE07A` | Light end of gold gradient, shimmer |
| `foil-glow` | `#FFF1A8` | Confetti, sparkle, premium sheen |

### 1.3 Functional (kept deliberately tiny)
| Token | Hex | Use |
|---|---|---|
| `text-white` | `#FFFFFF` | Bold headlines & numbers on purple |
| `text-soft` | `#F1E9FF` | Body copy on dark (lilac-tinted white, less glare) |
| `text-mute` | `#B79ED6` | Captions, secondary labels |
| `signal-coral` | `#FF5C7A` | **Only** destructive / negative-delta (never decorative) |
| `signal-mint` | `#3CE0B0` | **Only** "you improved" up-arrows (used sparingly) |

> Discipline rule: the palette is **purple + gold + white**, with coral and mint as rare functional signals. If a screen has more than those, cut something.

### 1.4 Gradients (the actual recipes)
```css
/* Studio spotlight — the signature. Record screen, win screens, hero moments. */
--grad-spotlight: radial-gradient(circle at 50% 40%,
  #A64BF4 0%, #7C2BE0 34%, #3B0F73 72%, #180530 100%);

/* Purple surface — buttons, chunky cards */
--grad-violet: linear-gradient(180deg, #8E2FE6 0%, #5A1BB0 100%);

/* Gold foil — reward CTAs, streak, Pro. Warm, metallic. */
--grad-foil: linear-gradient(135deg, #FFE07A 0%, #F6C324 46%, #E8A317 100%);

/* Foil sheen — animated shimmer swept across gold on wins/Pro */
--grad-sheen: linear-gradient(105deg, transparent 32%, rgba(255,255,255,.55) 48%, transparent 62%);
```

### 1.5 Contrast / accessibility rules
- **White + bold Fraunces on purple** is the default headline treatment — high contrast, always safe.
- **Gold text** (`foil-gold`) only at **large + bold** on `studio-ink`/`studio-grape`. Never gold body text at 15px.
- Body copy is `text-soft`, never gold, never pure `studio-lilac` at small sizes.
- Coral/mint are shape-and-icon reinforced (▲/▼, not color alone) so meaning survives color-blindness.
- Maintain WCAG AA for all text; the spotlight center is bright enough that headlines over it use a subtle radial darken behind them.

---

## 2. Typography

### 2.1 The pairing (deliberate)
- **Display / brand — Fraunces.** The hero face. Its optical-size and SOFT/WONK axes give it warmth and character (not a cold Didone). Used with restraint but boldly: the wordmark, screen titles, **all big numbers** (score, streak, WPM), and big emotional lines. Weights: **Black (900)** for numbers/titles, Bold (700) for section heads. Turn SOFT up slightly for friendliness; keep WONK low so it stays legible.
- **UI / body — Nunito.** Rounded, friendly, extremely legible at small sizes — the Duolingo-adjacent warmth without copying their exact face. Carries buttons, labels, paragraphs, inputs, captions. Weights: ExtraBold (800) for buttons/labels, SemiBold (600) for body.

> Why not Fraunces everywhere: a display serif at 14px in dense UI hurts readability and slows a nervous first-time user. Fraunces *owns the emotion*; Nunito *does the work*. That split is the whole trick.

### 2.2 Type scale (mobile, px)
| Role | Font / weight | Size / leading | Notes |
|---|---|---|---|
| Score / streak number | Fraunces 900 | 88 / 0.95 | Counts up on reveal |
| Screen hero title | Fraunces 900 | 40 / 1.05 | White on purple |
| Card / section title | Fraunces 700 | 26 / 1.1 | |
| Subhead | Fraunces 600 | 20 / 1.2 | |
| Body L | Nunito 600 | 17 / 1.5 | |
| Body | Nunito 600 | 15 / 1.5 | `text-soft` |
| Button label | Nunito 800 | 17 / 1 | Sentence case |
| Eyebrow / label | Nunito 800 | 12 / 1, +8% tracking, UPPERCASE | `text-mute` or gold |
| Caption | Nunito 600 | 12 / 1.3 | `text-mute` |

---

## 3. Layout & spacing

- **Spacing scale (4-base):** 4, 8, 12, 16, 20, 24, 32, 40, 48, 56, 64. Screen gutters = 20. Card padding = 20–24.
- **Radius:** `sm 12`, `md 16`, `lg 24`, `xl 32`, `pill 999`. The app leans large-radius (friendly).
- **Grid:** single-column, thumb-first. Primary action always in the bottom third, full-width. Nothing critical in the top corners.
- **Elevation:** on dark, "raise" with a lighter surface (`studio-grape`) + a soft violet glow shadow, not a gray drop-shadow.

```
--shadow-card: 0 8px 24px rgba(24,5,48,.45);
--glow-focus:  0 0 0 4px rgba(166,75,244,.45);   /* orchid focus ring */
--glow-gold:   0 8px 20px rgba(246,195,36,.35);  /* under gold CTAs */
```

---

## 4. Components (the Duolingo-chunky kit)

### 4.1 The pressable "candy" button (signature interaction)
Two-layer button with a darker **bottom edge** of the same hue, so it looks like a physical key you press down.

- **Primary gold CTA** ("Record", "Post it"): fill `--grad-foil`, 6px bottom edge `foil-amber`, label Nunito 800 in `studio-ink` (dark text on gold reads best), radius `lg`, glow-gold beneath.
- **Primary purple CTA** (secondary actions): fill `--grad-violet`, bottom edge `studio-royal`, white label.
- **Press behavior:** translateY(+4px), bottom edge shrinks to 2px — the "click down" feel. 90ms.
- **Ghost / tertiary:** transparent, `studio-lilac` 1.5px border, `text-soft` label.

### 4.2 Cards
`studio-grape` fill, radius `xl`, padding 24, `--shadow-card`. Prompt cards get a thin `studio-lilac` @ 15% hairline. "Reward" cards (streak, Pro) swap to `--grad-foil` with `studio-ink` text.

### 4.3 The record button
A large gold **mic pill** centered in the spotlight: 96px, `--grad-foil`, mic glyph, subtle breathing pulse at rest, ringed by a circular **timer arc** that fills as you talk (arc in `foil-sun`). This is the emotional center of the app — give it room.

### 4.4 Score dial + delta chip
Big Fraunces number (88px, white) that **counts up** on reveal, inside a circular progress ring (gold). Beside it a **delta chip**: pill, mint bg @ 15% + `▲ +6` in mint (or coral `▼` for a dip). The delta is the point (§PRD: coach tracks deltas, never grades).

### 4.5 Filler-word chips
Small pills listing caught fillers with counts: `"um" ×4`, `"like" ×3`. Neutral `studio-royal` fill, `text-soft`. Tapping one scrolls the transcript to that moment (fillers highlighted in gold-underline).

### 4.6 Tip cards
Stacked cards, each = one coaching tip. Left rail icon (lightbulb/mic/arrow), Fraunces 20 title ("Lead with your point"), Nunito 15 body. Max 3. Forward-looking copy only.

### 4.7 Streak flame
A **gold** flame (our version of Duolingo's orange), number in Fraunces. Lit = `--grad-foil`; at-risk = desaturated with a coral ember; freeze available = a little shield.

### 4.8 Progress / XP
Chunky rounded progress bars (`foil-gold` fill on `studio-royal` track, 12px tall, fully rounded). "Yap points" earned per rep.

### 4.9 Bottom tab bar
5 tabs, big filled rounded icons: **Today** (mic), **Coach/Yapbot** (speech bubble), **Record** (center, raised gold FAB), **Friends** (people), **Profile** (chart/crown). Active = `studio-orchid` + label; inactive = `studio-lilac`.

### 4.10 Yapbot mascot
A friendly character = **a rounded purple speech-bubble/orb with a little gold mic**, expressive eyes, gentle idle bob. Appears in onboarding, the scripting flow, empty states, and celebrations (throws gold-foil confetti on a win). Keep it charming, never Clippy — it speaks only when useful. (Illustration to be commissioned; specced as a slot now.)

### 4.11 Inputs
`studio-grape` fill, radius `md`, `text-soft`, `studio-lilac` placeholder, orchid `--glow-focus` on focus. Voice-input mic on the right for Yapbot.

---

## 5. Motion

Purposeful, tied to the "stage" metaphor. All respect `prefers-reduced-motion` (fall back to instant/opacity).

- **Spotlight bloom:** on entering Record/win screens, the radial spotlight scales 0.9→1 + brightens over 500ms. The "lights come up."
- **Button press:** the candy compression (§4.1).
- **Score count-up:** number ticks 0→final over ~900ms with an ease-out; ring fills in sync.
- **Win celebration:** gold-foil confetti burst + sheen sweep (`--grad-sheen`) across the score card; Yapbot tosses confetti. Reserved for real milestones (first yap, streak marks, new PR) so it stays special.
- **Streak flame:** subtle flicker loop (2–3s).
- **Transitions:** screens push with a soft parallax; cards rise 8px + fade in on load. Nothing bounces gratuitously.

---

## 6. Iconography & imagery
- **Icons:** rounded, thick-stroke (2.5px) or filled, friendly corners. Consistent set (mic, flame, bubble, chart, crown/mic-drop, shield, sparkle).
- **Video/audio frames:** yap thumbnails sit in `xl`-radius frames; audio-only yaps render an animated `foil-gold` **waveform** on `--grad-violet` (so audio yaps look as good as video).
- **Backgrounds:** default `studio-ink`; hero moments swap to `--grad-spotlight`. Avoid stock photography entirely — the brand is gradient + type + mascot.

---

## 7. Screen-by-screen UI

ASCII wireframes are structural, not pixel-final. Every screen: `studio-ink` base unless noted.

### 7.1 Onboarding — the un-scary first rep
```
┌────────────────────────────┐
│        (Yapbot orb)        │   Fraunces 40 white:
│                            │   "Let's find your voice."
│  What do you want to get   │   Nunito 17 text-soft
│  out of Yap?               │
│  ┌──────────────────────┐  │   Chunky selectable cards
│  │ 🎬 Start posting     │  │   (candy style, purple)
│  ├──────────────────────┤  │
│  │ 💪 Get more confident│  │
│  ├──────────────────────┤  │
│  │ 👀 Just curious      │  │
│  └──────────────────────┘  │
│                            │
│   [ Continue ]  (gold CTA) │
└────────────────────────────┘
```
Then: pick 3–5 interest chips (gold when selected) → **first yap screen** copy: *"15 seconds. Audio only. Nobody sees this but you."* Big gold mic. No score after — instead Yapbot: *"That's it. You just yapped."* + confetti. Real loop revealed as "here's what you unlocked."

### 7.2 Today (home)
```
┌────────────────────────────┐
│  🔥 7   (Fraunces, gold)   │  streak top-left; Pro spark top-right
│                            │
│  TODAY'S YAP  (eyebrow)    │  gold uppercase label
│  ┌──────────────────────┐  │
│  │  Fraunces 26 white:  │  │  ← prompt card, studio-grape
│  │ "What's a hill you'll│  │
│  │  die on?"            │  │
│  │  ⏱ ~60s · 🌶 spicy    │  │  meta chips
│  └──────────────────────┘  │
│                            │
│  [ 🎤 Yap it ]  gold CTA   │  ← primary, bottom third
│  [ Help me script ] ghost  │  → Yapbot
│                            │
│  ── Your week ──           │  mini streak calendar (7 dots)
└──[Today][Coach](●)[Fr][Me]─┘
```

### 7.3 Yapbot scripting
Chat-style, mascot pinned top. User types/speaks their angle → Yapbot returns a **scaffold card**: HOOK / MIDDLE / CLOSE as three labeled beats (Fraunces labels, Nunito lines), with "make it funnier / shorter / another angle" chips. Big **"Record this"** gold CTA. "Just record" always available top-right.

### 7.4 Record — the studio
```
┌────────────────────────────┐   background: --grad-spotlight
│   "What's a hill you'll    │   prompt pinned small, top
│    die on?"  (Fraunces 20) │
│                            │
│         ╭────────╮         │
│         │ timer  │         │   circular timer arc (foil-sun)
│         │  arc   │         │   around...
│         │  🎤    │         │   the gold mic button (96px)
│         ╰────────╯         │
│        00:23 / 01:00       │   Fraunces number
│                            │
│   [audio ⇄ video]  toggle  │   audio default
│         [ Stop ]           │
└────────────────────────────┘
```
Minimal chrome, lights up on entry. No live metrics.

### 7.5 Score & coaching
```
┌────────────────────────────┐   subtle spotlight top
│           82               │   Fraunces 88 white, counts up
│      ● gold ring ●         │   inside gold progress ring
│      ▲ +6 vs last          │   mint delta chip
│                            │
│  FILLERS  (eyebrow gold)   │
│  [um ×4][like ×3][so ×2]   │   chips
│  Pace 148 wpm · 58s        │
│                            │
│  ┌── Try next time ──────┐ │   tip cards (max 3)
│  │ 💡 Lead with the point│ │
│  └───────────────────────┘ │
│  ✨ "Your DMV line landed" │   highlight, gold
│                            │
│  [ This one's good → Post ]│   gold CTA appears if score high
│  [ Save private ] [Send ▸ ]│
└────────────────────────────┘
```
The "→ Post" gold CTA is the **unlock moment** (practice → content reward).

### 7.6 Win / streak celebration
Full `--grad-spotlight`, Yapbot center tossing gold-foil confetti, Fraunces headline ("7-day streak!"), sheen sweep, one gold CTA ("Keep going"). Milestones only.

### 7.7 Profile
Fraunces name + handle, streak + total yaps as big gold numbers. **Skill-trend** cards: sparklines (fillers ▼, clarity ▲) in mint/gold with deltas. **Highlight reel**: horizontal row of best-yap thumbnails in `xl` frames. Everything private until shared. `[V1.5]` public-profile toggle.

### 7.8 Friends / Dojo feed `[V1.5]`
Vertical feed of friends' yaps (video frame or gold waveform), prompt shown as context, like / comment / **Yap back** (gold) controls. Framing copy reinforces "everyone's leveling up." Post-to-feed is an explicit per-yap choice; default stays private.

### 7.9 Paywall — Yap Pro
This is where gold goes maximal: a `--grad-foil` card with animated sheen, Fraunces "Yap Pro", benefit list with gold checks, big gold CTA. The one screen allowed to feel lavish.

---

## 8. Voice & UX copy
- **Register:** warm, plain, a little cheeky. Sentence case. Short. Encouraging, never clinical.
- **Actions say what happens:** "Yap it", "Post it", "Send to friends", "Save private". The button that says "Post it" produces a toast "Posted."
- **Never grade, always nudge:** feedback is "Try leading with your point" not "Weak structure (4/10)."
- **Empty states are invitations:** e.g. friends tab empty → "No yaps yet. Send your first one and start the chain." + gold CTA.
- **Errors are calm and directive:** upload failed → "That yap didn't upload. Tap to retry — it's saved on your phone." No apologies, no blame.

---

## 9. Accessibility & quality floor
- WCAG AA contrast on all text (gold only large+bold; body always `text-soft`/white).
- Color never the sole signal (icons + text on deltas, streak states, errors).
- Visible keyboard/focus rings (orchid glow); large tap targets (≥44px; the candy buttons are bigger).
- `prefers-reduced-motion` respected everywhere (spotlight/confetti/count-up degrade to fades).
- Captions on all video yaps by default (also an accessibility win).
- Dynamic type: layouts reflow; Fraunces numbers cap-scale gracefully.

---

## 10. Design tokens (quick reference for build)
```css
:root{
  /* purple */
  --studio-ink:#180530; --studio-grape:#2C0A56; --studio-royal:#4A159C;
  --studio-violet:#7C2BE0; --studio-orchid:#A64BF4; --studio-lilac:#C9A6F0;
  /* gold */
  --foil-amber:#E8A317; --foil-gold:#F6C324; --foil-sun:#FFE07A; --foil-glow:#FFF1A8;
  /* text + signal */
  --text-white:#FFFFFF; --text-soft:#F1E9FF; --text-mute:#B79ED6;
  --signal-coral:#FF5C7A; --signal-mint:#3CE0B0;
  /* gradients */
  --grad-spotlight:radial-gradient(circle at 50% 40%,#A64BF4 0%,#7C2BE0 34%,#3B0F73 72%,#180530 100%);
  --grad-violet:linear-gradient(180deg,#8E2FE6 0%,#5A1BB0 100%);
  --grad-foil:linear-gradient(135deg,#FFE07A 0%,#F6C324 46%,#E8A317 100%);
  --grad-sheen:linear-gradient(105deg,transparent 32%,rgba(255,255,255,.55) 48%,transparent 62%);
  /* radius */ --r-sm:12px; --r-md:16px; --r-lg:24px; --r-xl:32px; --r-pill:999px;
  /* type */ --font-display:'Fraunces'; --font-ui:'Nunito';
}
```

---

## 11. Fonts to license/embed
- **Fraunces** — Google Fonts (open, free), variable (opsz, wght, SOFT, WONK). Bundle Black + Bold + SemiBold.
- **Nunito** — Google Fonts (open, free), variable. Bundle ExtraBold + SemiBold.
Both self-hosted/bundled in-app for offline + consistent rendering.

---

## 12. Open design questions
1. **Yapbot mascot design** — commission an illustrator; needs a few expressions + a confetti pose. Defines a lot of the app's charm.
2. **Light mode?** — recommend **dark-only at launch** (the studio metaphor is inherently dark; light mode dilutes it). Revisit later.
3. **Video frame treatment** — how much purple "letterboxing" around vertical video vs. full-bleed. Test both.
4. **App icon** — gold mic on `--grad-spotlight`, Fraunces "Y". Needs exploration.
```
```
