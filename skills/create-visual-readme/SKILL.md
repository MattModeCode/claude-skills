---
name: create-visual-readme
description: >
  Create or rebuild a project's README.md — with a bias toward *showing* the project, not just
  describing it. Trigger on "readme", "write/update the readme", "make the readme", "put
  screenshots in the readme", "add a gif to the readme", "show off the app/game", "landing-page
  readme", or any request to make a repo's front page interesting to a newcomer. For any project
  with a runnable visual UI (game, desktop GUI, web app), this skill captures REAL screenshots and
  a short gameplay/usage GIF from the actual app and builds a lean visual landing page. For
  libraries/CLIs with no visual surface, it falls back to a clean, concise text README. Floor, not
  a ceiling.
---

# create-readme

You're a senior open-source engineer who knows a README's job on a public repo: in ten seconds,
make a stranger understand what this is and want to try it. Prose alone rarely does that for a
visual project — **a moving image and a few real screenshots do.** So the default for anything with
a runnable UI is: drive the real app, capture it, and lead with those visuals.

## Decide the mode first

- **Visual app** — a game, desktop GUI, or web app you can launch and see. → Do the full
  **capture-and-showcase** flow below. This is the point of this skill.
- **Library / CLI / backend** with no visual surface. → Skip capture; jump to
  [Non-visual fallback](#non-visual-fallback).

If unsure, check for a main scene / entry window / dev server. When in doubt and it *can* render
something, capture it.

---

## Capture-and-showcase workflow (visual projects)

Worked example throughout: **Octet**, a Godot rhythm game. Adapt the mechanics to the stack in
front of you — the *shape* of the strategy is what transfers, not the Godot specifics.

### 1. Assess

- Find how to launch the real app (not the editor/IDE chrome): the engine binary + project path,
  or the dev-server URL. Octet: `Godot_v4.7.exe --path .` opens the game window, no editor toolbar.
- Confirm `ffmpeg` is available (needed for the GIF): `which ffmpeg` (or `(Get-Command ffmpeg)`).
- If the project's own instructions mandate design fidelity to mockups, **re-fetch the mockups live**
  before you judge whether a screen looks right — don't trust memory.

### 2. Map the screens + find a clean-capture mode

- List the handful of screens worth showing: one **hero** (the core loop in motion) plus **4–6
  stills** that convey range (e.g. gameplay, content/library browser, editor/creator, community,
  results/output).
- Find a way to make each shot look *flawless and busy*, not empty or mid-fumble:
  - a **demo / autoplay / attract mode** (Octet has an `autoplay` mod → perfect run, full combo);
  - or **seeded state** you set up before capturing (a loaded document, a populated list, a finished
    result). Trace how the app receives its data (Octet hands charts to gameplay via a `PlaySession`
    autoload) and set that up in the harness.

### 3. Capture stills with a *temporary* harness

Build a throwaway harness that drives each screen and saves a **real framebuffer PNG**, then delete
it. Never ship it.

- **Godot** — a temporary **autoload** (it survives `change_scene`, unlike a scene node which gets
  freed on navigation). It `await`s each screen settling, then
  `get_viewport().get_texture().get_image().save_png("res://docs/screenshots/<name>.png")`. Register
  it in `project.godot`'s `[autoload]`, run the game headed, then **revert the autoload line**. A
  ready-to-adapt template is in [`references/godot-capture-harness.gd`](references/godot-capture-harness.gd) —
  read it; it's the exact technique that produced Octet's shots.
- **Web** — route screenshots and recording through **`/browse`** (per the machine contract: never
  use claude-in-chrome tools), or Playwright if the repo already has it. Navigate each route, wait
  for load/animation, screenshot the viewport.
- **Native / other** — OS window capture as a fallback (on Windows, a PowerShell
  `System.Drawing`/`CopyFromScreen` grab of the app window). Prefer a real in-app framebuffer save
  when the engine offers one — it's cleaner and deterministic.

Capture at a crisp resolution (1920×1080, or the app's native size — Octet renders 1280×720). Leave
authentic in-app debug overlays; don't fake anything.

### 4. Honesty check on what you captured

**The trap:** a "demo mode" can distort real values. Octet's autoplay is perfect for *motion*, but it
**zeroes the score and stamps the run "UNRANKED"** — on a results hero shot that reads as a bug, not
a flex.

**Rule: the showcased state must be both flattering *and* truthful.** If the easy demo path fakes or
blanks values that matter, drive the underlying system through its **real API** instead. For Octet's
results shot I discarded the autoplay flag and instead fed the judge engine hand-timed *perfect*
`on_lane_press`/`on_lane_release` calls — a genuine, ranked SS / Full Combo / All Perfect through the
same code real play uses. Same beautiful screen, real numbers.

### 5. Record the hero GIF

- Capture ~8–12s of the best motion:
  - **Godot** — Movie Maker: `Godot --path . --write-movie <scratch>/clip.avi --fixed-fps 60 -- <args>`,
    with the harness in a "movie" mode that boots straight into the action (autoplay is fine here —
    a GIF shows motion, not a scoreboard) and quits after N seconds.
  - **Web / other** — `/browse` video capture or a screen recorder.
- Convert to an **optimized, looping** GIF with ffmpeg's two-pass palette (crisp colour, small file):

  ```bash
  ffmpeg -y -i clip.avi -vf "fps=15,scale=720:-1:flags=lanczos,split[a][b];[a]palettegen=stats_mode=diff[p];[b][p]paletteuse=dither=bayer" -loop 0 gameplay.gif
  ```

  Aim ~720px wide, 12–15fps, **under ~5 MB** (GitHub embeds GIFs inline; oversized ones hurt more
  than help). Verify: extract a mid-clip frame
  (`ffmpeg -i gameplay.gif -vf "select=eq(n\,110)" -update 1 -frames:v 1 f.png`) and look at it. Keep
  the raw video in scratch, commit only the GIF.

### 6. Write the lean landing-page README

Structure (this is the floor — improve on it):

- **Centered header** — keep the existing **logo** and shields **badges verbatim** (find them in the
  current README; don't regenerate). One-line hook tagline that says what the thing *is*.
- **GIF hero** immediately under the badges — the first thing a visitor sees.
- **Screenshot gallery** — a two-column HTML `<table>` of the stills, each cell with a **one-line
  caption** naming the screen. (A lone wide shot — e.g. a results screen — can sit centered below.)
- **"Why you'll like it"** — 3–4 **benefit-first** bullets. Tight. No "not live yet" caveats here.
- **Controls / usage** — a compact table or block, only if relevant.
- **Download / install** — condensed to the essentials; bury long first-launch or per-OS caveats
  (SmartScreen, Gatekeeper `xattr`, `chmod +x`) inside a `<details>` block.
- **Footer: "Under the hood" / "More"** — a short link list to `docs/`, `CONTRIBUTING`,
  `CHANGELOG`, architecture, design docs. This absorbs depth **without deleting it** — details live
  one click away. Do **not** paste LICENSE/CONTRIBUTING/CHANGELOG bodies into the README; link them.
- **Honesty** — preserve accurate hedges the project already curated ("no backend yet", "coming
  soon", "unsigned build"). Never overclaim. Match the repo's spelling/voice (for these projects:
  Canadian spelling, sentence-case headings), minimal emoji, GFM, and GitHub admonition syntax where
  it helps.

Use relative paths for every asset (`docs/screenshots/…`) so they render on GitHub.

### 7. Clean up (do not skip)

- Delete the capture harness file(s) and any `.uid`/cache siblings.
- **Revert every config edit** (the temporary autoload line, any dev flag). The app must boot
  normally afterward — verify it.
- Remove scratch video from the repo. The *only* committed changes are `README.md` and the
  screenshot/GIF assets.
- Respect the project's version-control contract — don't commit/push unless the repo's own rules say
  to (Octet's, for instance, forbid it; the human commits).

### Verify

Open each new PNG and the GIF: no editor/IDE chrome, correct framing, real and flattering content,
GIF loops cleanly and is under budget. Preview the README: logo + badges intact, every image and
link resolves, `<table>`/`<details>` render. Confirm the harness and config edits are gone and the
app still launches.

---

## Non-visual fallback

For a library, CLI, or backend with no visual surface, skip capture and write a clean, concise text
README:

- Senior-OSS tone; appealing, informative, easy to scan. Don't overuse emoji.
- What it is → install → minimal usage example → key features → links. Lead with a runnable example.
- GFM formatting; GitHub admonitions (`> [!NOTE]`, `> [!WARNING]`) where they add value.
- **Don't** add LICENSE / CONTRIBUTING / CHANGELOG sections — link the dedicated files instead.
- Use the project's logo/icon in the header if one exists.
