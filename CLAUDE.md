# CLAUDE.md

This file provides guidance to Claude Code when working with this repository.

## Project Overview

PDF Modifier MCP - A PDF text modification tool with dual interfaces:
- **CLI** (`pdf-mod`): Human-friendly command-line interface
- **MCP Server** (`pdf-modifier-mcp`): AI agent interface via Model Context Protocol

## Build & Test Commands

```bash
# Setup
make setup                 # Install all dependencies + pre-commit hooks

# Development
make dev                   # Start MCP server (stdio)
make cli                   # Show CLI help
make repl                  # Python REPL with package loaded

# Quality
make check                 # Run lint + type + test (use this before commits)
make test                  # Run tests with coverage
make lint                  # Run ruff linter
make format                # Auto-format code
make type                  # Run mypy

# Docker
make docker-build          # Build Docker image
make docker-up             # Start services via docker-compose
make docker-cli            # Test CLI in Docker

# Release (automated via PR merge to master)
make version               # Show current version
make build                 # Build wheel and sdist
```

## Architecture

```
src/pdf_modifier_mcp/
├── core/                  # Pure business logic (no I/O dependencies)
│   ├── analyzer.py        # PDFAnalyzer: text extraction, structure
│   ├── modifier.py        # PDFModifier: find/replace with style preservation
│   ├── models.py          # Pydantic schemas (ReplacementSpec, etc.)
│   └── exceptions.py      # PDFModifierError hierarchy
└── interfaces/            # Entry points
    ├── cli.py             # Typer + Rich CLI
    └── mcp.py             # FastMCP server
```

## Key Patterns

- **ReplacementSpec**: All replacements go through this Pydantic model
- **Hyperlinks**: Append `|URL` to replacement (e.g., `"Click|https://example.com"`)
- **Void links**: Use `|void(0)` to neutralize links
- **Context Manager**: `with PDFModifier(in, out) as mod:` for cleanup
- **MCP Tools**: `read_pdf_structure`, `inspect_pdf_fonts`, `modify_pdf_content`

## Git Workflow (GitHub Flow)

**Branches:**
- `master`: Main branch (releases happen here)
- `feat/*`, `fix/*`, etc.: Feature branches

**Commit Convention (enforced by pre-commit):**
```bash
feat: add new feature      # → Minor release (0.X.0)
fix: bug fix               # → Patch release (0.0.X)
feat!: breaking change     # → Major release (X.0.0)
docs: update readme        # → No release
chore: update deps         # → No release
```

**Release Flow:**
1. Create feature branch from `master` (`feat/my-feature`)
2. Work with conventional commits
3. Create PR to `master`
4. On PR merge, semantic-release automatically:
   - Analyzes commits to determine version bump
   - Updates `pyproject.toml` version
   - Generates `CHANGELOG.md`
   - Creates git tag
   - Publishes to PyPI
   - Creates GitHub Release

## Testing

```bash
# Run all tests
make test

# Quick test (stop on first failure)
make test-fast

# Test structure:
tests/
├── test_unit.py           # Unit tests for core modules
├── test_interfaces.py     # CLI and MCP interface tests
└── test_integration.py    # End-to-end workflows
```

## Pre-commit Hooks

Installed automatically with `make setup`:
- trailing-whitespace, end-of-file-fixer
- ruff (lint + format)
- mypy (type checking)
- gitleaks (secret detection)
- conventional-pre-commit (commit message validation)
