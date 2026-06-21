# gdrive-bulk-download

> Claude Code skills, published. Point Claude at a pile of Google Drive
> links and it downloads them all — even on restricted or managed Google
> Workspace accounts that can't install a Drive connector or browser
> extension.

This repo is where I publish my [Claude Code](https://claude.com/claude-code)
skills. It starts with one — `gdrive-bulk-download` — and is structured so
more can be dropped in alongside it over time.

## Skills Library

| Skill | Description |
|---|---|
| [`gdrive-bulk-download`](./skills/gdrive-bulk-download) | Bulk-download Google Docs, Slides, and Drive-hosted PDF/DOCX/PPTX files from a list of links, including on restricted/managed Workspace accounts. |

## What it does

Give Claude a pile of Google Drive links (pasted in the prompt, or in a `.txt`
file, one URL per line) and it will download them all to a single timestamped
folder:

- **Google Docs** → exported to PDF
- **Google Slides** → exported to PDF
- **Drive files** already stored as PDF / DOCX / PPTX → downloaded as-is
- **Google Sheets** → reported as unsupported (not downloaded)

It writes a `manifest.json` next to the files tracking every input URL and its
status (`ok` / `unsupported` / `error`), and reports a summary at the end. A
single failure never aborts the batch.

Because it drives a real headless browser session, it works with **restricted or
managed Google Workspace accounts** that can't install Claude's Drive connector,
a Drive MCP, or browser extensions.

## Requirements

- **[Claude Code](https://claude.com/claude-code)**
- **[gstack](https://github.com/getgrit/gstack)** — `gdrive-bulk-download` is
  **not functional without it**. It uses gstack's headless `browse` binary
  (referenced as `$B`, expected at `~/.claude/skills/gstack/browse/dist/browse`)
  for all navigation and downloads.
- A Google account with access to the files, logged in within the browse session
  (see [Authentication](#authentication)).

## Installation

Clone this repo and copy (or symlink) the skill you want into your Claude Code
skills directory:

```bash
git clone https://github.com/MattModeCode/gdrive-bulk-download.git
cp -r gdrive-bulk-download/skills/gdrive-bulk-download ~/.claude/skills/
```

Or symlink it so you can `git pull` updates in place:

```bash
ln -s "$(pwd)/gdrive-bulk-download/skills/gdrive-bulk-download" \
  ~/.claude/skills/gdrive-bulk-download
```

Restart Claude Code (or start a new session) and the skill will be available.

## Usage

Just ask Claude to download some links. It triggers automatically when you paste
Drive URLs or point at a file of them.

**Paste links directly:**

```
Download these to ~/Downloads:
https://docs.google.com/document/d/FILE_ID/edit
https://docs.google.com/presentation/d/FILE_ID/edit
https://drive.google.com/file/d/FILE_ID/view
```

**Point at a file of links** (one URL per line; blank lines and `#` comments
ignored):

```
Bulk download every link in ~/links.txt into ~/Downloads/clients
```

Output lands in `<output-dir>/<DD-MM-YYYY_HH-MM>/` (defaults to `~/Downloads`),
with all files plus a `manifest.json` for the run.

## Supported / unsupported types

| Input URL | Resolved type | Output |
|---|---|---|
| `docs.google.com/document/d/{ID}` | Google Doc | PDF |
| `docs.google.com/presentation/d/{ID}` | Google Slides | PDF |
| `drive.google.com/file/d/{ID}` (or `open?id={ID}`) | Drive file | original `.pdf` / `.docx` / `.pptx` |
| Direct `.pdf` / `.docx` / `.pptx` URL | Direct file | as-is |
| `docs.google.com/spreadsheets/d/{ID}` | Google Sheet | **unsupported** — skipped |
| Anything else | — | **unsupported** — skipped |

## Authentication

The skill checks for a logged-in Google session before downloading. If you're
not authenticated:

- It will use gstack's `/connect-chrome` + a manual `handoff` so you can complete
  login/MFA yourself, then resume.

> [!WARNING]
> Cookie import (`/setup-browser-cookies`) is unreliable for restricted/managed
> accounts. Google auth cookies often get scoped to a country-TLD domain (e.g.
> `.google.ca`) that doesn't carry over to `drive.google.com` / `docs.google.com`.
> Prefer `/connect-chrome` + manual login for those accounts.

## License

[MIT](./LICENSE)
