# create-visual-readme

Create or rebuild a project's README.md with a bias toward *showing* the project instead of
just describing it. For anything with a runnable visual UI — a game, a desktop GUI, a web app —
it drives the real app, captures actual screenshots and a short GIF, and builds a lean visual
landing page around them. It triggers automatically on requests like "update the readme", "put
screenshots in the readme", "add a gif of the app", or "show off the game" — you don't need to
name it.

## Requirements

- **[Claude Code](https://claude.com/claude-code)**.
- **`ffmpeg`** on `PATH` — required for the GIF step (palette-optimized, looping GIF from a
  recorded clip). The rest of the skill still works without it; you just won't get a GIF.
- No hard dependency for screenshots themselves, but the capture method depends on the stack:
  - **Godot** — just the engine binary; the skill builds a temporary in-engine capture harness
    (template included, see below).
  - **Web** — [gstack](https://github.com/getgrit/gstack)'s `/browse`, if the environment has it
    (never claude-in-chrome tools).
  - **Other native apps** — falls back to an OS-level window capture.

## Usage

```
Rewrite the README for this game — make it interesting for someone landing on the repo for
the first time, with real screenshots and a gif if you can.
```

```
Update the readme with screenshots of the editor, the main menu, and gameplay.
```

For a library or CLI with no visual surface, just ask normally ("write a README for this
package") — the skill detects there's nothing to capture and writes a clean text README instead.

## Output

- **`README.md`** rewritten as a lean landing page: existing logo/badges kept verbatim, a GIF
  hero under them, a screenshot gallery (two-column table, one caption per shot), 3–4
  benefit-first feature bullets, condensed install/download (long OS-specific caveats folded
  into a `<details>` block), and a footer linking out to `CONTRIBUTING`/`CHANGELOG`/architecture
  docs rather than duplicating them.
- **`docs/screenshots/*.png`** — one still per showcased screen, captured from the real,
  running app (not a mockup, not the editor/IDE chrome).
- **`docs/screenshots/*.gif`** — a short (~8–12s), palette-optimized, looping clip of the core
  loop in motion, sized to stay under a few MB so it embeds cleanly on GitHub.
- For non-visual projects: a concise text `README.md` only — no screenshots, no gif.

All capture tooling is temporary. The skill deletes the harness file(s) and reverts any config
edit it made to wire the harness in (e.g. a temporary autoload) before finishing — the only
committed changes are the README and the image/gif assets.

## Companion files

- **`references/godot-capture-harness.gd`** — a ready-to-adapt Godot autoload template (stills
  mode + a movie-recording mode for the GIF clip, using `get_viewport().get_texture().get_image()`
  to save real framebuffer PNGs). This file **is committed** in this repo; open it directly when
  the project you're documenting is a Godot game.

## Honesty rule (read this before trusting a demo/autoplay mode)

A demo or autoplay mode is great for making a capture look busy and flawless, but it can also
**distort real values** — e.g. an autoplay flag that zeroes the score and flags the run
"unranked" would make a results-screen screenshot look like a bug, not a flex. The rule the
skill follows: the showcased state must be both **flattering and truthful**. When the easy demo
path fakes or blanks a value that matters, drive the underlying system through its real API
instead (e.g. feed hand-timed perfect inputs through the same press/release calls a real player
would trigger) so the screenshot shows a genuine result.

## Troubleshooting

- **No GIF produced** — check `ffmpeg` is on `PATH`. The skill still produces the screenshot
  gallery and README without it.
- **Screenshot shows editor/IDE chrome instead of the running app** — the harness must launch
  the app directly (e.g. the engine binary against the project path), not run it from inside an
  open editor session, which usually adds a debug toolbar to the window.
- **A results/summary screen looks wrong (zero score, "unranked", empty state)** — see the
  honesty rule above; the demo mode is misrepresenting real state and the capture needs to drive
  the real code path instead.
