"""Core business logic for PDF modification."""

from .analyzer import PDFAnalyzer
from .exceptions import (
    FileSizeError,
    InvalidPatternError,
    PDFModifierError,
    PDFNotFoundError,
    PDFReadError,
    PDFWriteError,
    TextNotFoundError,
)
from .models import (
    FontInspectionResult,
    FontMatch,
    ModificationResult,
    PageStructure,
    PDFStructure,
    ReplacementSpec,
    TextElement,
)
from .modifier import PDFModifier

__all__ = [
    # Classes
    "PDFAnalyzer",
    "PDFModifier",
    # Models
    "FontInspectionResult",
    "FontMatch",
    "ModificationResult",
    "PageStructure",
    "PDFStructure",
    "ReplacementSpec",
    "TextElement",
    # Exceptions
    "FileSizeError",
    "InvalidPatternError",
    "PDFModifierError",
    "PDFNotFoundError",
    "PDFReadError",
    "PDFWriteError",
    "TextNotFoundError",
]
