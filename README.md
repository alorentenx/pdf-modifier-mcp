# PDF Modifier MCP

A robust Python tool for modifying text within PDF files while preserving the original layout and font styles. Features dual interfaces: a human-friendly CLI and an MCP server for AI agent integration.

[![CI](https://github.com/mlorentedev/pdf-modifier-mcp/actions/workflows/ci.yml/badge.svg)](https://github.com/mlorentedev/pdf-modifier-mcp/actions/workflows/ci.yml)
[![PyPI version](https://badge.fury.io/py/pdf-modifier-mcp.svg)](https://badge.fury.io/py/pdf-modifier-mcp)
[![Python 3.10+](https://img.shields.io/badge/python-3.10+-blue.svg)](https://www.python.org/downloads/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Features

- **Text Replacement**: Find and replace text while preserving font styles
- **Regex Support**: Pattern-based replacements for dates, IDs, prices
- **Hyperlink Management**: Create or neutralize clickable links
- **Style Preservation**: Matches bold/regular fonts using Base 14 fonts
- **Dual Interface**: CLI for humans, MCP server for AI agents
- **Structured Output**: JSON responses for programmatic processing

## Installation

### From PyPI

```bash
pip install pdf-modifier-mcp
```

### From Source

```bash
git clone https://github.com/mlorentedev/pdf-modifier-mcp.git
cd pdf-modifier-mcp
poetry install
```

### Docker

```bash
docker pull mlorentedev/pdf-modifier-mcp
# Or build locally
docker build -t pdf-modifier-mcp .
```

## Quick Start

### CLI Usage

```bash
# Simple text replacement
pdf-mod modify input.pdf output.pdf -r "old text=new text"

# Multiple replacements
pdf-mod modify input.pdf output.pdf -r "$99.99=$149.99" -r "Draft=Final"

# Regex replacement (dates, IDs, etc.)
pdf-mod modify input.pdf output.pdf -r "Order #\d+=Order #REDACTED" --regex

# Create hyperlinks
pdf-mod modify input.pdf output.pdf -r "Click Here=Visit Site|https://example.com"

# Analyze PDF structure
pdf-mod analyze input.pdf --json

# Inspect fonts for specific terms
pdf-mod inspect input.pdf "Invoice" "Total" "$"
```

### MCP Server (for AI Agents)

```bash
# Start the MCP server (stdio transport)
pdf-modifier-mcp
```

## Claude Desktop Integration

Add to your Claude Desktop configuration (`claude_desktop_config.json`):

```json
{
  "mcpServers": {
    "pdf-modifier": {
      "command": "pdf-modifier-mcp",
      "args": []
    }
  }
}
```

Or with Docker:

```json
{
  "mcpServers": {
    "pdf-modifier": {
      "command": "docker",
      "args": ["run", "-i", "--rm", "-v", "/path/to/pdfs:/data", "mlorentedev/pdf-modifier-mcp"]
    }
  }
}
```

### Available MCP Tools

| Tool | Description |
|------|-------------|
| `read_pdf_structure` | Extract complete PDF structure with text positions and fonts |
| `inspect_pdf_fonts` | Search for terms and report their font properties |
| `modify_pdf_content` | Find and replace text with style preservation |

## Usage Examples

### Price Adjustment

```bash
pdf-mod modify invoice.pdf updated.pdf \
  -r "$27.99=$45.00" \
  -r "$111.70=$128.71"
```

### Document Anonymization

```bash
pdf-mod modify document.pdf redacted.pdf \
  -r "Order # \d{3}-\d{7}-\d{7}=Order # REDACTED" \
  -r "John Doe=REDACTED" \
  --regex
```

### Date Rolling

```bash
pdf-mod modify report.pdf updated.pdf \
  -r "January \d{2}, 2024=February 01, 2025" \
  --regex
```

### Hyperlink Neutralization

```bash
# Disable existing links
pdf-mod modify doc.pdf safe.pdf -r "Click Here=Click Here|void(0)"
```

## Docker Usage

```bash
# Run CLI commands
docker run --rm -v $(pwd)/data:/data pdf-modifier-mcp \
  pdf-mod modify /data/input.pdf /data/output.pdf -r "old=new"

# Run MCP server
docker run -i --rm -v $(pwd)/data:/data pdf-modifier-mcp

# Using docker-compose
docker compose run cli modify /data/input/doc.pdf /data/output/result.pdf -r "old=new"
```

## Development

### Quick Start

```bash
# Full setup (dependencies + pre-commit hooks)
make setup

# Run all checks (lint, type, test)
make check

# Start MCP server
make dev
```

### Makefile Commands

| Command | Description |
|---------|-------------|
| `make setup` | Install dependencies and pre-commit hooks |
| `make test` | Run tests with coverage |
| `make lint` | Run ruff linter |
| `make type` | Run mypy type checker |
| `make check` | Run all checks (lint, type, test) |
| `make dev` | Start MCP server (stdio) |
| `make cli` | Show CLI help |
| `make docker-build` | Build Docker image |
| `make docker-run` | Run MCP server in Docker |

### Manual Commands

```bash
# Install with dev dependencies
poetry install

# Run tests
poetry run pytest

# Run with coverage
poetry run pytest --cov=src --cov-report=term-missing

# Linting and type checking
poetry run ruff check src/
poetry run mypy src/

# Pre-commit hooks
poetry run pre-commit install
poetry run pre-commit run --all-files
```

### Git Workflow

Development uses **GitHub Flow**:

1. Create feature branch from `master` (`feat/*`, `fix/*`, etc.)
2. Use conventional commits (`feat:`, `fix:`, `docs:`, etc.)
3. Create PR to `master` when ready
4. Merging triggers automatic semantic versioning

### Commit Convention

Commits must follow [Conventional Commits](https://conventionalcommits.org/):

```bash
feat: add new feature        # → minor version bump (0.1.0 → 0.2.0)
fix: resolve bug             # → patch version bump (0.1.0 → 0.1.1)
docs: update readme          # → no version bump
chore: update dependencies   # → no version bump
BREAKING CHANGE: ...         # → major version bump (0.1.0 → 1.0.0)
```

Pre-commit hooks validate commit messages automatically.

## Architecture

```
src/pdf_modifier_mcp/
├── core/               # Pure business logic
│   ├── analyzer.py     # PDF text extraction and structure
│   ├── modifier.py     # Text replacement engine
│   ├── models.py       # Pydantic schemas
│   └── exceptions.py   # Typed error hierarchy
└── interfaces/         # Entry points
    ├── cli.py          # Typer + Rich CLI
    └── mcp.py          # FastMCP server
```

## Documentation

- [Roadmap](docs/ROADMAP.md): Development phases and changelog
- [LLM Context](docs/llm.txt): AI/LLM agent context file

## Contributing

1. Fork the repository
2. Create a feature branch from `master` (`feat/my-feature`)
3. Make changes with conventional commits
4. Run `make check` to verify
5. Submit a PR to `master`

## License

MIT License - see [LICENSE](LICENSE) for details.
