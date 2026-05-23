# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Pandoc-based resume/CV pipeline that converts Markdown source files into PDF, HTML, DOCX, and RTF formats. GitHub Actions automatically rebuilds PDFs on every push.

## Build Commands

```bash
make all          # Build all formats (HTML, PDF, DOCX, RTF)
make pdf          # Build PDFs via Pandoc → ConTeXt
make html         # Build HTML with CSS styling and Lua link filter
make docx         # Build Word documents
make rtf          # Build RTF documents
make clean        # Remove all generated output files
docker compose up # Build PDFs using Docker (no local Pandoc needed)
```

**Dependencies:** Pandoc 2.2.1, ConTeXt (for PDF generation)

### Docker on Apple Silicon

The Dockerfile pulls an amd64 `pandoc-*.deb`, so on arm64 Macs the image must be built/run under emulation, and ConTeXt's format files need to be generated on first run:

```bash
DOCKER_DEFAULT_PLATFORM=linux/amd64 docker compose run --rm resume-make \
  sh -c "mtxrun --generate && context --make && make pdf"
```

Without `mtxrun --generate && context --make`, the container errors with `mtxrun | unknown script 'mtx-context.lua'` and produces `.tex` files but no PDFs.

## Architecture

- `markdown/` — Source `.md` files (cv.md, cv_en.md, resume.md). This is where content is edited. The Makefile globs `markdown/*.md`, so any new `.md` dropped here is built automatically.
- `styles/` — Templates: `chmduquesne.tex` (PDF/LaTeX) and `chmduquesne.css` (HTML). Style is set via `STYLE` variable in Makefile.
- `output/` — Generated files (gitignored)
- `pdc-links-target-blank.lua` — Pandoc Lua filter that adds `target="_blank"` to HTTP links in HTML output
- `action-a/` — GitHub Action: Dockerfile (Debian-based with Pandoc+ConTeXt) and `entrypoint.sh` (runs `make pdf`)
- `.github/workflows/main.yml` — CI workflow: builds PDFs on push, uploads `output/cv_en.pdf` and `output/cv.pdf` as artifacts

## PDF Build Pipeline

Markdown → Pandoc (with `.tex` template) → ConTeXt `.tex` file → ConTeXt compiles to PDF. This is a two-step process, not direct Pandoc-to-PDF.
