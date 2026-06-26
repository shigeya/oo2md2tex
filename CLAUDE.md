# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

oo2md2tex is a Ruby gem that converts OmniOutliner files (.oo3 v3 / .ooutline v5/v6) to LaTeX via an extended Markdown intermediate format. The pipeline is: OmniOutliner → Markdown text (oo2text) → TeX (md2tex).

## Build & Test

Unit tests use minitest (`test/test_*.rb`):

```bash
rake test
```

Integration testing is also done via sample builds:

```bash
# v3 sample
cd sample/v3 && bundle install && make sample.pdf

# v5 sample
cd sample/v5 && bundle install && make sample.pdf

# v6 sample
cd sample/v6 && bundle install && make sample.pdf
```

PDF generation requires `latex` and `dvipdfmx` to be installed.

## Architecture

Three-stage pipeline with two main executables in `bin/`:

- **oo2text**: Parses OmniOutliner XML (SAX-based via REXML, pure Ruby) and outputs extended Markdown. Handles v3 (gzip XML) and v5/v6 (ZIP package) formats separately. v6-saved `.ooutline` files still use the v5 namespace internally, so the same `V5::Parser` handles both.
- **md2tex**: Reads extended Markdown from stdin/files and outputs TeX. Uses Redcarpet with a custom renderer (`lib/markdown_to_tex/renderer.rb`). Optional `--git` flag embeds git metadata in output.

Library code in `lib/markdown_to_tex/`:
- `processor.rb` — Orchestrates conversion, captures git metadata, runs Redcarpet
- `renderer.rb` — Custom Redcarpet renderer outputting TeX instead of HTML
- `text_processor.rb` — Handles section headers, citations (`[cite_key]` → `\CITE{}`), cross-references (`[this:sec]`), label mapping, description format (`((TEXT))` → `\ITEM{}`), and macro expansion

## Extended Markdown Format

The project uses a custom Markdown dialect documented in `Format.md`. Key features:
- Section headers with optional labels and short titles: `# Long Title | Short [label]`
- Citations: `[key]` or `[key1, key2]`
- Cross-references with namespace prefixes: `sec:`, `fig:`, `tab:`, etc.
- LaTeX pass-through via raw HTML blocks
- Comment lines with `%` prefix

## Additional Utilities

- `bin/ja-ten-maru-normalize` — Japanese punctuation normalization
- `bin/ja-count` — Japanese character counting
- `tools/oo2.watchr` — File watcher for continuous build (requires `watchr` gem)
