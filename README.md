# claude-skills

> A growing library of my published [Claude Code](https://claude.com/claude-code) skills —
> drop one into `~/.claude/skills/` and go.

This repo is where I publish the Claude Code skills I build. A [skill](https://claude.com/claude-code)
is a folder with a `SKILL.md` that teaches Claude Code a repeatable capability; Claude loads
it automatically when a task matches its description. Each skill here is self-contained and
documented on its own page — the table below is the index, and it grows over time as I add more.

## Skills Library

| Skill | What it does | Docs |
|---|---|---|
| [`gdrive-bulk-download`](./skills/gdrive-bulk-download) | Bulk-download Google Docs, Slides, and Drive-hosted PDF/DOCX/PPTX files from a list of links — including on restricted/managed Workspace accounts that can't install a Drive connector or extension. | [README](./skills/gdrive-bulk-download/README.md) |
| [`mashuai-brand`](./skills/mashuai-brand) | The MashuAI brand system — colour, typography, components, and voice rules applied whenever Claude builds or styles anything visual under the MashuAI umbrella. | [README](./skills/mashuai-brand/README.md) |

## Installation

Each skill is a folder under [`skills/`](./skills). Clone the repo and copy the one you want
into your Claude Code skills directory, replacing `<skill>` with its folder name:

```bash
git clone https://github.com/MattModeCode/claude-skills.git
cp -r claude-skills/skills/<skill> ~/.claude/skills/
```

Or symlink it so `git pull` updates the skill in place:

```bash
ln -s "$(pwd)/claude-skills/skills/<skill>" ~/.claude/skills/<skill>
```

Restart Claude Code (or start a new session) and the skill becomes available. It triggers
automatically when your request matches it — you don't need to name it.

## Requirements

- **[Claude Code](https://claude.com/claude-code)** for every skill.
- Individual skills may have their own dependencies and setup. See each skill's README
  (linked in the table above) for its exact requirements, usage, and configuration.
