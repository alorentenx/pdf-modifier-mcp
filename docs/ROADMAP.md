# Roadmap: PDF Modifier MCP

This document outlines completed features and planned GitHub issues for future development.

> **See Also**: [llm.txt](./llm.txt) for LLM/agent context.

---

## Current Release: v0.0.1

Initial release with dual-interface PDF modification capabilities.

### Included Features
- Text replacement with style preservation
- Regex pattern support
- Hyperlink creation/neutralization
- CLI interface (Typer + Rich)
- MCP server interface (FastMCP)
- Pydantic models for validation
- Typed exception hierarchy
- 88% test coverage
- CI/CD with semantic release
- Docker support

---

## GitHub Issues (Future Work)

### Phase 1: Advanced Text Handling

| Issue | Title | Labels |
|-------|-------|--------|
| #1 | Text reflow: handle oversized replacement text | `enhancement`, `core` |
| #2 | Font embedding: support custom TrueType/OpenType fonts | `enhancement`, `core` |
| #3 | Multi-line regex: patterns spanning multiple text spans | `enhancement`, `core` |

### Phase 2: Enhanced Analysis

| Issue | Title | Labels |
|-------|-------|--------|
| #4 | Table extraction: detect and parse tables to JSON | `enhancement`, `analyzer` |
| #5 | Image replacement: swap images (logos, etc.) | `enhancement`, `core` |
| #6 | Form filling: native AcroForms support | `enhancement`, `core` |
| #7 | Link inventory: list existing hyperlinks | `enhancement`, `analyzer` |
| #8 | Batch processing: multiple PDFs in one call | `enhancement`, `cli`, `mcp` |

### Phase 3: Extended Capabilities

| Issue | Title | Labels |
|-------|-------|--------|
| #9 | OCR support: handle scanned PDFs via Tesseract | `enhancement`, `core` |
| #10 | PDF/A output: archival format support | `enhancement`, `core` |
| #11 | Password protection: read/write encrypted PDFs | `enhancement`, `security` |
| #12 | Watermarking: add text/image watermarks | `enhancement`, `core` |
| #13 | Digital signatures: verify and add signatures | `enhancement`, `security` |

---

## Release Workflow

Releases are automated via **semantic-release** based on conventional commits:

### GitHub Flow
1. Create feature branch from `master` (`feat/*`, `fix/*`, etc.)
2. Create PR to `master` when ready
3. PR merge triggers the release workflow

### Automatic Versioning
| Commit Prefix | Version Bump | Example |
|---------------|--------------|---------|
| `feat:` | Minor | 0.0.1 → 0.1.0 |
| `fix:`, `perf:` | Patch | 0.0.1 → 0.0.2 |
| `BREAKING CHANGE:` | Major | 0.0.1 → 1.0.0 |
| `docs:`, `chore:`, `ci:` | None | — |

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────┐
│                    Entry Points                      │
├──────────────────────┬──────────────────────────────┤
│   CLI (Typer+Rich)   │      MCP (FastMCP)           │
│   pdf-mod command    │   pdf-modifier-mcp server    │
│   Human interaction  │   LLM interaction            │
└──────────────────────┴──────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────┐
│                   Core Layer                         │
├─────────────────────────────────────────────────────┤
│  modifier.py   │  analyzer.py  │  models.py         │
│  PDFModifier   │  PDFAnalyzer  │  Pydantic schemas  │
│                │               │                     │
│  exceptions.py │               │                     │
│  Error types   │               │                     │
└─────────────────────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────┐
│                   PyMuPDF (fitz)                     │
│              PDF manipulation engine                 │
└─────────────────────────────────────────────────────┘
```

---

## Changelog

### v0.0.1 (2026-01-13)
- Initial release
- Dual-interface: CLI (`pdf-mod`) and MCP server (`pdf-modifier-mcp`)
- Text replacement with font style preservation
- Regex pattern support
- Hyperlink creation and neutralization
- PDF structure analysis and font inspection
- Multi-stage Docker image with security hardening
- GitHub Actions CI/CD with semantic release
- PyPI trusted publishing
- 88% test coverage

---

*Last Updated: 2026-01-13*
