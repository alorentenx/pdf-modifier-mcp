# =============================================================================
# Makefile – PDF Modifier MCP
# =============================================================================
# Project orchestration for development, testing, and deployment.
#
# Quick start:
#   make setup    Install dependencies and pre-commit hooks
#   make test     Run test suite with coverage
#   make dev      Start MCP server for development
# =============================================================================

SHELL := /bin/bash
.SHELLFLAGS := -c -o pipefail

POETRY ?= poetry
PYTHON_VERSION ?= 3.12
DOCKER_IMAGE := pdf-modifier-mcp
DOCKER_TAG := latest

.DEFAULT_GOAL := help

# -----------------------------------------------------------------------------
# Help
# -----------------------------------------------------------------------------
.PHONY: help
help:
	@echo "=== PDF Modifier MCP ==="
	@echo ""
	@echo "Setup:"
	@echo "  make setup              Install dependencies and pre-commit hooks"
	@echo "  make setup-dev          Install dev dependencies only"
	@echo ""
	@echo "Development:"
	@echo "  make dev                Start MCP server (stdio)"
	@echo "  make cli                Show CLI help"
	@echo "  make repl               Start Python REPL with package loaded"
	@echo ""
	@echo "Quality:"
	@echo "  make test               Run tests with coverage"
	@echo "  make test-fast          Run tests without coverage"
	@echo "  make lint               Run ruff linter"
	@echo "  make format             Format code with ruff"
	@echo "  make type               Run mypy type checker"
	@echo "  make check              Run all checks (lint, type, test)"
	@echo "  make pre-commit         Run pre-commit on all files"
	@echo ""
	@echo "Docker:"
	@echo "  make docker-build       Build Docker image"
	@echo "  make docker-run         Run MCP server in Docker"
	@echo "  make docker-cli         Run CLI in Docker"
	@echo "  make docker-up          Start services with docker-compose"
	@echo ""
	@echo "Release:"
	@echo "  make build              Build wheel and sdist"
	@echo "  make release VERSION=x.y.z  Bump version, tag, and prepare release"
	@echo "  make clean              Remove build artifacts"
	@echo ""
	@echo "Documentation: See docs/ROADMAP.md"

# -----------------------------------------------------------------------------
# Setup
# -----------------------------------------------------------------------------
.PHONY: setup
setup: setup-python setup-poetry setup-dependencies setup-hooks
	@echo "✓ Setup complete. Run 'make dev' to start the MCP server"

.PHONY: setup-python
setup-python:
	@if ! command -v python3 >/dev/null 2>&1; then \
		echo "Error: Python 3 is required"; \
		exit 1; \
	fi
	@python3 --version

.PHONY: setup-poetry
setup-poetry:
	@if ! command -v poetry >/dev/null 2>&1; then \
		echo "Installing Poetry..."; \
		python3 -m pip install --upgrade poetry >/dev/null 2>&1; \
	fi
	@$(POETRY) config virtualenvs.create true
	@$(POETRY) config virtualenvs.in-project true

.PHONY: setup-dependencies
setup-dependencies:
	@$(POETRY) install
	@echo "✓ Dependencies installed"

.PHONY: setup-dev
setup-dev:
	@$(POETRY) install --only dev
	@echo "✓ Dev dependencies installed"

.PHONY: setup-hooks
setup-hooks:
	@$(POETRY) run pre-commit install
	@$(POETRY) run pre-commit install --hook-type commit-msg
	@echo "✓ Pre-commit hooks installed"

# -----------------------------------------------------------------------------
# Development
# -----------------------------------------------------------------------------
.PHONY: dev
dev:
	@echo "Starting MCP server (stdio transport)..."
	@$(POETRY) run pdf-modifier-mcp

.PHONY: cli
cli:
	@$(POETRY) run pdf-mod --help

.PHONY: repl
repl:
	@$(POETRY) run python -ic "from pdf_modifier_mcp.core import *; print('Loaded: PDFModifier, PDFAnalyzer, ReplacementSpec')"

# -----------------------------------------------------------------------------
# Quality Assurance
# -----------------------------------------------------------------------------
.PHONY: test
test:
	@$(POETRY) run pytest --cov=src --cov-report=term-missing --cov-report=xml

.PHONY: test-fast
test-fast:
	@$(POETRY) run pytest -x -q

.PHONY: test-watch
test-watch:
	@$(POETRY) run pytest-watch

.PHONY: lint
lint:
	@$(POETRY) run ruff check src/ tests/

.PHONY: format
format:
	@$(POETRY) run ruff check --fix src/ tests/
	@$(POETRY) run ruff format src/ tests/
	@echo "✓ Code formatted"

.PHONY: type
type:
	@$(POETRY) run mypy src/

.PHONY: check
check: lint type test
	@echo "✓ All checks passed"

.PHONY: pre-commit
pre-commit:
	@$(POETRY) run pre-commit run --all-files

# -----------------------------------------------------------------------------
# Docker
# -----------------------------------------------------------------------------
.PHONY: docker-build
docker-build:
	@docker build -t $(DOCKER_IMAGE):$(DOCKER_TAG) .
	@echo "✓ Docker image built: $(DOCKER_IMAGE):$(DOCKER_TAG)"

.PHONY: docker-run
docker-run:
	@docker run -i --rm -v $(PWD)/data:/data $(DOCKER_IMAGE):$(DOCKER_TAG)

.PHONY: docker-cli
docker-cli:
	@docker run --rm -v $(PWD)/data:/data --entrypoint pdf-mod $(DOCKER_IMAGE):$(DOCKER_TAG) --help

.PHONY: docker-up
docker-up:
	@docker compose up -d
	@echo "✓ Services started"

.PHONY: docker-down
docker-down:
	@docker compose down
	@echo "✓ Services stopped"

.PHONY: docker-clean
docker-clean:
	@docker rmi $(DOCKER_IMAGE):$(DOCKER_TAG) 2>/dev/null || true
	@echo "✓ Docker images removed"

# -----------------------------------------------------------------------------
# Release
# -----------------------------------------------------------------------------
.PHONY: build
build: clean
	@$(POETRY) build
	@echo "✓ Built dist/"
	@ls -la dist/

.PHONY: release
release:
ifndef VERSION
	$(error VERSION is required. Usage: make release VERSION=0.3.0)
endif
	@echo "Releasing version $(VERSION)..."
	@$(POETRY) version $(VERSION)
	@git add pyproject.toml
	@git commit -m "chore: bump version to $(VERSION)"
	@git tag -a "v$(VERSION)" -m "Release v$(VERSION)"
	@echo "✓ Version $(VERSION) tagged. Run 'git push && git push --tags' to publish"

.PHONY: version
version:
	@$(POETRY) version

# -----------------------------------------------------------------------------
# Cleanup
# -----------------------------------------------------------------------------
.PHONY: clean
clean:
	@rm -rf dist/ build/ *.egg-info/
	@rm -rf .pytest_cache/ .mypy_cache/ .ruff_cache/
	@rm -rf htmlcov/ coverage.xml .coverage
	@find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	@echo "✓ Cleaned build artifacts"

.PHONY: clean-all
clean-all: clean docker-clean
	@rm -rf .venv/
	@echo "✓ Cleaned everything including venv"
