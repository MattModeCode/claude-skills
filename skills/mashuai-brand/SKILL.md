---
name: mashuai-brand
description: >
  The MashuAI brand system — the single source of truth for how anything under the MashuAI
  umbrella looks, reads, and feels (logo, colour, typography, UI components, voice). Load this
  skill whenever you build, design, style, or write copy for ANYTHING visual or brand-facing:
  websites, web apps, dashboards, React components, HTML pages, landing pages, UI mockups, app
  icons, n8n workflow diagrams, marketing material, or product names. Also trigger on "use my
  brand", "MashuAI style", "make it look good", "make it on-brand", "dark theme", "our colours",
  or any request that produces something a user will see. This brand is dark, minimal, and quietly
  technical. Never guess at colours, type, or layout — always apply this skill.
---

# MashuAI Brand System

MashuAI is an umbrella brand. Everything shipped under it — apps, sites, tools, diagrams,
marketing — should feel like it came from the same studio: dark, minimal, confident, quietly
technical. This file is the foundation. Detailed component specs and niche surfaces live in
`references/`; the logo and its construction rules live in `assets/logo/`.

## Identity

Reference feeling: a tool built by engineers, for engineers. Think Cursor.com and Grok.com —
restrained, functional, quietly futuristic without being flashy or cyberpunk. No decoration for
decoration's sake. Every element earns its place. When a choice is between "more" and "less,"
choose less and make what remains sharper.

Three words to hold in mind on every output: **dark, minimal, deliberate.**

---

## Logo

The MashuAI mark is a single light-silver glyph centred on a near-black rounded square — a simple,
weighty downward form. It is the clearest expression of the whole brand: one shape, two tones, no
ornament. The asset and full construction notes are in `assets/logo/` — read
`assets/logo/logo-style.md` before drawing, regenerating, or placing the mark, or before making
any new icon or wordmark that needs to sit in the same family.

Core rules (full set in the logo folder):
- **Two tones only.** Mark `#e1e0e0` on square `#0f0e13`. Never recolour the mark.
- **Keep it simple.** New marks/icons in this family stay single-glyph, geometric, flat — same
  restraint as the master mark. No gradients, no detail, no inner shadows.
- **Clear space** equal to the glyph's stroke width on all sides; never crowd it.
- **Minimum size** 24px square on screen — below that the form muddies.
- The mark reads on near-black or pure black. Avoid placing it on light or busy backgrounds; if
  you must, use the inverted lockup described in the logo folder, not an ad-hoc recolour.

---

## Colour palette

The palette is near-monochrome by design: a stack of neutral darks, two tiers of light text, and a
single white/silver accent. Colour is information, not decoration — the only saturated values are
reserved for status.

### Backgrounds
| Role | Hex | Usage |
|---|---|---|
| Page background | `#0a0a0f` | Root / outermost background |
| Surface / card | `#0f0f14` | Cards, panels, sidebars (~5% lighter) — also the logo square shade |
| Elevated surface | `#141419` | Dropdowns, modals, tooltips |
| Hover state | `#1a1a21` | Hover on interactive rows/items |

No tint. Pure neutral dark — no blue, purple, or green cast in the surfaces.

### Text
| Role | Hex | Usage |
|---|---|---|
| Primary text | `#e2e8f0` | Body, labels, headings |
| Secondary text | `#94a3b8` | Captions, placeholders, muted info |
| Disabled / hint | `#475569` | Disabled states, very secondary |

Use the `#94a3b8` token for secondary text — never fake it with `opacity: 0.5` on primary text.

### Accent — white/silver, single accent only
| Role | Hex / value | Usage |
|---|---|---|
| Primary accent | `#e2e8f0` | Active/focus borders, button outlines, highlights |
| Accent dim | `rgba(226,232,240,0.15)` | Ghost-button fill, subtle fills |
| Accent faint | `rgba(226,232,240,0.06)` | Hover fills, active-row backgrounds |

The accent **is** the text colour, used sparingly for emphasis and interactive chrome. This keeps
the look monochromatic and calm. (The logo mark is the pure-neutral sibling `#e1e0e0`; for UI,
stay on `#e2e8f0`.)

### Signature accent — optional, currently none
The brand ships **monochrome**. If a single signature accent is ever adopted, it drops in here as
one value used only for the most important interactive moment (primary CTA, active brand element),
never as decoration. Until one is chosen, do not introduce a coloured accent.

### Semantic colours — status only, never decoration
| State | Hex |
|---|---|
| Success | `#22c55e` |
| Warning | `#f59e0b` |
| Error / danger | `#ef4444` |
| Info | `#60a5fa` |

---

## Typography

**One typeface, everywhere: JetBrains Mono** (fallback `'Space Mono', monospace`). Headings use the
same family at heavier weight and slightly tighter tracking — the monospace itself carries the
technical character, so no second font is needed.

Load from Google Fonts:
`https://fonts.googleapis.com/css2?family=JetBrains+Mono:wght@400;500;600&display=swap`

| Role | Size | Weight | Letter-spacing |
|---|---|---|---|
| Display / h1 | 28–32px | 500 | `-0.02em` |
| h2 | 20–22px | 500 | `-0.01em` |
| h3 | 16–18px | 500 | `0` |
| Body | 14px | 400 | `0` |
| Caption / label | 12px | 400 | `0.02em` |
| Code / inline mono | 13px | 400 | `0` |

Line-height: 1.6 body, 1.3 headings.

Rules:
- **Sentence case always** — no Title Case, no ALL CAPS (exception: keyboard-shortcut labels).
- No text smaller than 11px.
- Max weight **500**. No 700+ bold anywhere — emphasis comes from colour and spacing, not weight.

---

## Spacing & layout

8px base grid. Density is balanced — not cramped, not airy.

| Token | Value | Usage |
|---|---|---|
| xs | 4px | Tight inline gaps |
| sm | 8px | Default component padding, small gaps |
| md | 16px | Card padding, section gaps |
| lg | 24px | Major section spacing |
| xl | 40px | Page-level separation |

Max content width: 1100–1200px, centred.

---

## Borders, radius, shadows

**Borders:** none by default. Separate elements with spacing and background contrast, not lines.
Sparing exceptions: focus ring `1px solid rgba(226,232,240,0.4)` (keyboard focus only); selected
state `1px solid rgba(226,232,240,0.3)`. Never decorative borders for structure.

**Radius:** slight, 4–6px across the board — buttons/inputs `5px`, cards `6px`, badges/tooltips/
icons `4px`. No pills, no sharp 0px. Rounding should be barely noticeable.

**Shadows:** subtle, black only — to hint depth, never to glow.
```css
/* card */      box-shadow: 0 1px 3px rgba(0,0,0,0.4), 0 1px 2px rgba(0,0,0,0.3);
/* elevated */  box-shadow: 0 4px 16px rgba(0,0,0,0.5), 0 2px 4px rgba(0,0,0,0.3);
```
No coloured shadows, no glow, no blur effects.

---

## Components

**Buttons — ghost / outline by default.**
```css
background: transparent;
border: 1px solid rgba(226,232,240,0.25);
color: #e2e8f0;
padding: 8px 16px;
border-radius: 5px;
font: 500 13px 'JetBrains Mono', monospace;
transition: background 150ms ease, border-color 150ms ease;
cursor: pointer;
/* hover  */ background: rgba(226,232,240,0.06); border-color: rgba(226,232,240,0.45);
/* active */ background: rgba(226,232,240,0.10);
```
Reserve a filled button (`background:#e2e8f0; color:#0a0a0f;`) for the single most critical CTA on a
page — at most one.

**Inputs.**
```css
background: #0f0f14;
border: 1px solid rgba(226,232,240,0.12);
border-radius: 5px;
color: #e2e8f0;
font: 400 13px 'JetBrains Mono', monospace;
padding: 8px 12px;
transition: border-color 150ms ease;
/* focus */ border-color: rgba(226,232,240,0.4); outline: none;
```

**Icons.** Outline only — Lucide or Tabler (`ti-*`), never filled. 16px inline, 20px standalone.
Colour inherits `currentColor`; coloured only to convey semantic status.

**Animation.** Minimal. Standard transition 150ms ease on background/border/opacity. Entrances
(modals, dropdowns) fade `opacity 0 → 1` over 120ms. No bounce/spring/elastic, nothing over 300ms,
no sliding/scaling/rotation except loading spinners.

**Navigation (web).** Top horizontal navbar: logo left, links left or centre, actions right.
Background `#0a0a0f` (or `#0a0a0fcc` with `backdrop-filter: blur(8px)`). No bottom border — use
contrast or shadow. Height 52–56px, padding `0 24px`. Active link `#e2e8f0`, inactive `#94a3b8`
transitioning to `#e2e8f0` on hover.

---

## Voice & tone

The brand writes the way it looks: plain, confident, lowercase-friendly, no hype. Sentence case in
UI and most copy. Say what a thing does, not how amazing it is. No exclamation marks in product
chrome, no emoji in UI. Names of products under the umbrella stay short, lowercase or single-word,
and avoid cute spellings. When in doubt, cut a word.

---

## Application notes

- **App icons / product marks** sit in the logo family: near-black rounded square, single light
  glyph, flat. Use `assets/logo/logo-style.md` as the template before generating a new one.
- **Web & app UI** apply the palette, type, and components above directly.
- **Marketing / decks** keep the same dark canvas and mono type; let whitespace and one strong
  glyph carry the page rather than imagery or colour.
- **n8n workflow diagrams** have their own surface — see `references/n8n-diagrams.md`.

---

## Never do

- No gradients (background or text)
- No coloured glow, neon, or coloured shadows
- No noise textures, grain, or mesh blobs
- No pill-shaped containers, no sharp 0px corners
- No vibrant accent as primary (no electric blue, purple, orange)
- No decorative borders purely for structure
- No animations over 300ms; no bounce/spring
- No font weight above 500
- No all-caps headings, no Title Case in UI
- No emoji in UI; no exclamation marks in product chrome
- No floating action buttons
- Never recolour the logo mark

---

## References

- `assets/logo/logo-style.md` — logo construction, clear space, lockups, generating in-family marks
- `references/ui-patterns.md` — extended component states, tables, empty states, focus order
- `references/n8n-diagrams.md` — node, canvas, and connection styling for n8n workflows
