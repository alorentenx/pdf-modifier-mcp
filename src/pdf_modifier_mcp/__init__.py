"""
PDF Modifier MCP - A dual-interface PDF modification tool.

Provides both CLI (pdf-mod) and MCP server interfaces for PDF manipulation.
"""

from .core import (
    PDFAnalyzer,
    PDFModifier,
    PDFModifierError,
    ReplacementSpec,
)

__version__ = "0.2.0"

__all__ = [
    "PDFAnalyzer",
    "PDFModifier",
    "PDFModifierError",
    "ReplacementSpec",
    "__version__",
]
