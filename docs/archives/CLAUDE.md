# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this folder contains

Two types of content:

- **sfeir.dev articles** (French) — numbered with prefix `NN-<slug>.md`, intended for publication
- **Reference docs** — cheatsheets and personal notes, not for publication

## Article series: `mise`

`00-mise-articles.md` is the planning doc for the full series. It defines:
- Article topics and their order
- Two structural templates to follow (Usage/How-to vs Vision/Architecture)
- LinkedIn post drafts

Published/draft articles so far:

| File | Topic | Status |
|------|-------|--------|
| `01-mise-install.md` | Install & configure mise | Draft |
| `02-mise-backend.md` | mise backends | Draft |

## Writing conventions

- Language: **French**
- Target platform: sfeir.dev (Ghost CMS)
- Style: follow the SFEIR style guide in `~/.claude/rules/sfeir-dev.md`
- Tone: vouvoiement ("vous"), voix active, pas de fluff
- Structure: see templates in `00-mise-articles.md`

## Reviewing articles

Use the `/review-article` skill to review an article before publication:

```bash
/review-article docs/01-mise-install.md
```

The skill checks attractivité, rédaction, code examples, factual claims, and cohérence.
