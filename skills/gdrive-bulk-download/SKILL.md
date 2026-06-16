---
name: gdrive-bulk-download
description: Bulk and mass download Google Docs, Google Slides decks, and Drive-hosted PDF, DOCX, or PPTX files from a list of links. Use whenever the user pastes several Google Docs, Slides, or Drive URLs, or points at a file of links with one URL per line, and wants them saved locally. Especially useful for restricted or managed Google Workspace accounts that cannot install Claude's Drive connector, browser extensions, or a Drive MCP. Exports Docs and Slides to PDF, downloads already-PDF/DOCX/PPTX Drive files as-is, and writes a manifest.json tracking every URL and its status. Reach for this any time the request is to download these docs, slides, or files, or to grab everything in a list, even if the user does not name the skill directly. Google Sheets links are reported as unsupported, not downloaded.
---

# gdrive-bulk-download

Bulk-download Google Docs, Google Slides decks, and existing PDF/DOCX/PPTX
files stored in Google Drive, using gstack's headless browser (`$B`) so it
works with restricted/managed accounts that can't install Claude's
Drive connector or browser extensions.

## Inputs

- A list of URLs, either pasted directly in the prompt (one per line, in
  any order, surrounding text ignored) or referenced as a file path
  (one URL per line; blank lines and `#`-comments ignored).
- Optional output directory argument. Defaults to `~/Downloads`.

## Procedure

### 1. Collect URLs

Parse every `https://docs.google.com/...` or `https://drive.google.com/...`
URL out of the prompt text, or read them from the referenced file (one per
line, skip blank lines and lines starting with `#`).

### 2. Verify authentication

```bash
B=~/.claude/skills/gstack/browse/dist/browse
$B goto https://drive.google.com
$B text
```

Check the page text/title for signs of a logged-in session (account name,
"My Drive", etc.) rather than a Google sign-in form. If not authenticated:

- Run `$B connect` then `$B goto https://drive.google.com` and
  `$B handoff "log into the restricted Google account"` so the user can
  complete login/MFA manually, then `$B resume`.
- `/setup-browser-cookies` is generally **unreliable** for restricted/managed
  accounts — observed failure mode: Google auth cookies (`SID`, `HSID`,
  `SAPISID`, etc.) get scoped to a country-TLD domain (e.g. `.google.ca`)
  that doesn't carry over to `drive.google.com`/`docs.google.com`. Prefer
  `/connect-chrome` + manual login for these accounts; only suggest cookie
  import for accounts known to work with it.

Do not proceed to downloads until an authenticated session is confirmed.

### 3. Classify and resolve each URL

For each input URL, extract the file ID (the segment after `/d/`) and
resolve a download URL:

| Pattern | Resolved type | Download URL |
|---|---|---|
| `docs.google.com/document/d/{ID}` | Google Doc | `https://docs.google.com/document/d/{ID}/export?format=pdf` |
| `docs.google.com/presentation/d/{ID}` | Google Slides | `https://docs.google.com/presentation/d/{ID}/export/pdf` |
| `docs.google.com/spreadsheets/d/{ID}` | Google Sheet | **unsupported** — skip, record in manifest, do not download |
| `drive.google.com/file/d/{ID}` (or `open?id={ID}`) | Drive file (PDF/DOCX/PPTX) | `https://drive.google.com/uc?export=download&id={ID}` |
| Any other direct `.pdf`/`.docx`/`.pptx` URL | Direct file | use as-is |

Anything that doesn't match one of these is also `unsupported`.

### 4. Determine a filename

For Docs/Slides/Drive files, navigate to the original (view) URL and read
the title:

```bash
$B goto "<original-url>"
$B js "document.title"
```

Strip trailing suffixes like ` - Google Docs`, ` - Google Slides`,
` - Google Drive`. Sanitize the remaining title for filesystem safety
(replace `/ \ : * ? " < > |` and control characters with `-`, collapse
whitespace, trim). Append the correct extension:

- Docs/Slides → `.pdf`
- Drive file → keep its real extension (`.pdf`/`.docx`/`.pptx`, inferred
  from the original URL/filename or `Content-Disposition`)

If a title can't be determined, fall back to the file ID as the filename.

### 5. Create the output directory

```bash
mkdir -p "<output-dir>/<DD-MM-YYYY_HH-MM>"
```

`<output-dir>` defaults to `~/Downloads`. Use one timestamp for the whole
run — don't create a new folder per file.

### 6. Download each resolved file

```bash
$B download "<download-url>" "<batch-dir>/<filename>" --navigate
```

`--navigate` handles Drive's redirect/confirmation chains for larger files.
If a download fails, record the error and continue with the rest — one
failure must not abort the batch.

### 7. Write the manifest

Write `<batch-dir>/manifest.json` as a JSON array, one entry per input URL:

```json
{
  "source_url": "...",
  "resolved_type": "google_doc | google_slides | drive_file | unsupported",
  "output_filename": "..." ,
  "format": "pdf | docx | pptx | null",
  "status": "ok | unsupported | error",
  "error": "..." 
}
```

### 8. Report to the user

Summarize: total processed, counts of `ok` / `unsupported` / `error`, the
batch directory path, and the filenames downloaded. For any auth-shaped
errors (redirected to a Google login page, 403s), suggest re-running
`/connect-chrome` (or `/setup-browser-cookies`, for accounts known to work
with it) and retrying just the failed URLs.
