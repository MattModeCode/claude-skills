# mashuai-brand

The single source of truth for how anything under the **MashuAI** umbrella looks, reads, and
feels — logo, colour, typography, UI components, and voice. MashuAI is a dark, minimal,
quietly technical brand (reference feeling: Cursor and Grok — restrained and functional, not
flashy). The three words to hold in mind on every output: **dark, minimal, deliberate.**

This is a reference skill: Claude loads it and applies the rules rather than running a
procedure. Use it so everything shipped under the brand looks like it came from the same studio.

## When it triggers

Whenever Claude builds, designs, styles, or writes copy for anything visual or brand-facing —
websites, web apps, dashboards, React components, HTML pages, landing pages, UI mockups, app
icons, n8n workflow diagrams, marketing material, or product names. Also on explicit cues
like "use my brand", "MashuAI style", "make it on-brand", "make it look good", "dark theme",
or "our colours".

## What it covers

| Area | Rules |
|---|---|
| **Identity** | Engineered, restrained, futuristic-not-cyberpunk. When choosing between more and less, choose less and sharpen what remains. |
| **Logo** | Single light-silver glyph on a near-black rounded square. Two tones only, never recoloured; clear space, 24px minimum, near-black backgrounds only. |
| **Colour** | Near-monochrome: neutral dark backgrounds, two tiers of light text, one white/silver accent. Saturated colour reserved for status only. |
| **Typography** | One typeface everywhere — JetBrains Mono. Sentence case always; max weight 500. |
| **Spacing & layout** | 8px base grid; 1100–1200px max content width, centred. |
| **Borders / radius / shadows** | No borders by default (separate with spacing/contrast); 4–6px radius; subtle black-only shadows, no glow. |
| **Components** | Ghost/outline buttons by default (one filled CTA max), `#0f0f14` inputs, outline-only icons, minimal ≤300ms animation. |
| **Voice** | Plain, confident, sentence case. Say what a thing does, not how amazing it is. No emoji or exclamation marks in product chrome. |
| **Never do** | No gradients, neon/coloured glow, noise textures, pills, vibrant primary accents, decorative borders, bounce/spring, font weight >500, all-caps/Title Case in UI, or recoloured logo. |

## At a glance

The anchor tokens, for quick reference (full tables, component CSS, and rationale are in
[`SKILL.md`](./SKILL.md)):

| Token | Value |
|---|---|
| Page background | `#0a0a0f` |
| Surface / card | `#0f0f14` |
| Elevated surface | `#141419` |
| Primary text / accent | `#e2e8f0` |
| Secondary text | `#94a3b8` |
| Disabled / hint | `#475569` |
| Typeface | JetBrains Mono (fallback `'Space Mono', monospace`) |
| Max font weight | 500 |
| Grid | 8px base |
| Radius | 4–6px |

Status colours (used only for status, never decoration): success `#22c55e`, warning
`#f59e0b`, error `#ef4444`, info `#60a5fa`.

## Companion files

`SKILL.md` points to three companion files for deeper guidance:

- `assets/logo/logo-style.md` — logo construction, clear space, lockups, generating in-family marks
- `references/ui-patterns.md` — extended component states, tables, empty states, focus order
- `references/n8n-diagrams.md` — node, canvas, and connection styling for n8n workflows

> [!NOTE]
> These companion files are referenced by `SKILL.md` but are **not yet committed to this
> repo**. The core brand system in `SKILL.md` works on its own; add these files to make the
> logo construction, extended UI patterns, and n8n diagram guidance fully usable.
