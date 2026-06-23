# gdrive-bulk-download

Bulk-download Google Docs, Google Slides decks, and Drive-hosted PDF/DOCX/PPTX files from a
list of links — into one timestamped folder, with a manifest. It drives a real headless
browser session, so it works on **restricted or managed Google Workspace accounts** that
can't install Claude's Drive connector, a Drive MCP, or browser extensions.

The skill triggers automatically whenever you paste several Drive/Docs URLs or point Claude
at a file of links and ask to download them — you don't need to name it.

## Requirements

- **[Claude Code](https://claude.com/claude-code)**.
- **[gstack](https://github.com/getgrit/gstack)** — the skill is **not functional without
  it**. It uses gstack's headless `browse` binary (referenced as `$B`, expected at
  `~/.claude/skills/gstack/browse/dist/browse`) for all navigation and downloads.
- A Google account with access to the files, logged in within the browse session (see
  [Authentication](#authentication)).

## Usage

**Paste links directly** (one per line, in any order — surrounding text is ignored):

```
Download these to ~/Downloads:
https://docs.google.com/document/d/FILE_ID/edit
https://docs.google.com/presentation/d/FILE_ID/edit
https://drive.google.com/file/d/FILE_ID/view
```

**Point at a file of links** (one URL per line; blank lines and `#` comments ignored):

```
Bulk download every link in ~/links.txt into ~/Downloads/clients
```

The output directory is optional and defaults to `~/Downloads`.

## Supported / unsupported types

| Input URL | Resolved type | Output |
|---|---|---|
| `docs.google.com/document/d/{ID}` | Google Doc | PDF |
| `docs.google.com/presentation/d/{ID}` | Google Slides | PDF |
| `drive.google.com/file/d/{ID}` (or `open?id={ID}`) | Drive file | original `.pdf` / `.docx` / `.pptx` |
| Direct `.pdf` / `.docx` / `.pptx` URL | Direct file | as-is |
| `docs.google.com/spreadsheets/d/{ID}` | Google Sheet | **unsupported** — skipped |
| Anything else | — | **unsupported** — skipped |

Docs and Slides are exported to PDF; Drive files already stored as PDF/DOCX/PPTX are
downloaded in their original format. Filenames come from each file's title (sanitized for
the filesystem), falling back to the file ID if a title can't be read.

## Output

Everything for a run lands in a single timestamped folder:

```
<output-dir>/<DD-MM-YYYY_HH-MM>/
├── <file title>.pdf
├── <file title>.docx
└── manifest.json
```

`manifest.json` is a JSON array with one entry per input URL:

```json
{
  "source_url": "...",
  "resolved_type": "google_doc | google_slides | drive_file | unsupported",
  "output_filename": "...",
  "format": "pdf | docx | pptx | null",
  "status": "ok | unsupported | error",
  "error": "..."
}
```

A single failure never aborts the batch — the file is recorded with `status: "error"` and the
run continues. At the end you get a summary: total processed, `ok` / `unsupported` / `error`
counts, the batch directory path, and the filenames downloaded.

## Authentication

The skill verifies a logged-in Google session before downloading and won't proceed without
one. If you're not authenticated, it uses gstack's `/connect-chrome` and a manual `handoff`
so you can complete login/MFA yourself, then resumes the batch.

> [!WARNING]
> Cookie import (`/setup-browser-cookies`) is unreliable for restricted/managed accounts.
> Google auth cookies (`SID`, `HSID`, `SAPISID`, …) often get scoped to a country-TLD domain
> (e.g. `.google.ca`) that doesn't carry over to `drive.google.com` / `docs.google.com`.
> Prefer `/connect-chrome` + manual login for those accounts; only use cookie import for
> accounts known to work with it.

## Troubleshooting

Auth-shaped failures — a redirect to a Google login page, or `403` responses — usually mean
the session expired or never authenticated. Re-run `/connect-chrome` (or
`/setup-browser-cookies` for accounts known to work with it), then retry just the failed URLs
listed in `manifest.json`.
