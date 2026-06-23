# CLAUDE.md

Guidance for Claude Code when working in this repo.

This is a personal library of published Claude Code skills. One folder per skill lives under
`skills/`. The job here is to keep every skill documented the same way, so the repo stays
consistent as it grows.

## Repo layout

```
README.md                      # generic library index — NEVER holds skill-specific detail
CLAUDE.md                      # this file
LICENSE
skills/
  <skill-name>/
    SKILL.md                   # the skill itself: frontmatter (name, description) + body
    README.md                  # human documentation for that skill
```

- **`SKILL.md`** is what Claude Code loads and runs. Its `description:` frontmatter drives
  auto-triggering — leave it alone when you're only writing docs; it's tuned separately.
- **`README.md`** (per skill) is the human-facing page someone reads when they browse into the
  folder. Skill-specific detail lives here, never in the root README.
- **Root `README.md`** is the index for the whole library and stays generic.

## When adding a new skill

Do all of these, in order:

1. Create `skills/<skill-name>/` containing the `SKILL.md`.
2. Write `skills/<skill-name>/README.md` using the template below.
3. Add one row to the **Skills Library** table in the root `README.md` (name links to the
   folder, Docs links to the skill's README):

   ```
   | [`<skill-name>`](./skills/<skill-name>) | <one line: what it does> | [README](./skills/<skill-name>/README.md) |
   ```
4. Keep the root README generic. If a skill needs a dependency, the root README mentions it
   only as "some skills require X" — exact requirements go in the skill's own README.
5. Update the GitHub **About** description only if the library's overall framing changes — not
   per skill.
6. Make the change on a branch and open a PR; don't push docs straight to `main`.

## Per-skill `README.md` template

Common skeleton for every skill, then a type-specific body.

```markdown
# <skill-name>

<One-line summary.> <When it auto-triggers — Claude loads it on a matching request; you
don't name it.>

## Requirements

- **[Claude Code](https://claude.com/claude-code)**.
- <Any hard dependency, e.g. gstack — note if the skill is non-functional without it.>

## Usage

<Concrete invocation examples / inputs.>
```

Then add the body that fits the skill's type:

- **Procedural skill** (performs a task — e.g. `gdrive-bulk-download`):
  supported/unsupported inputs table, an **Output** section (files produced + any
  `manifest.json`/result schema), failure behavior (e.g. "one failure never aborts the
  batch"), and **Troubleshooting**.
- **Reference skill** (supplies rules/tokens — e.g. `mashuai-brand`):
  a **What it covers** map, an **At a glance** table of anchor values, and notes on any
  companion files.

If `SKILL.md` references companion files (e.g. `assets/`, `references/`) that aren't committed,
flag it with a `> [!NOTE]` admonition rather than implying they exist.

## Style

- GitHub Flavored Markdown. Use GitHub admonitions (`> [!NOTE]`, `> [!WARNING]`) where useful.
- Sparing emoji.
- No `License` / `Contributing` / `Changelog` sections in any README — the root `LICENSE`
  file covers licensing.
- Commit messages: `docs: …`, imperative mood, scoped to the change.
