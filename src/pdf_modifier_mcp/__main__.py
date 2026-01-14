"""
Entry point for `python -m pdf_modifier_mcp`.

Launches the MCP server by default.
Use `pdf-mod` command for CLI access.
"""

from .interfaces.mcp import main

if __name__ == "__main__":
    main()
