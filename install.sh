#!/bin/bash
# =====================================================================
# LAT Installer - Linux/macOS
# =====================================================================
# Usage: curl -fsSL https://raw.githubusercontent.com/Yoannoza/latex-compiler/main/install.sh | bash
# =====================================================================

set -e

REPO="Yoannoza/latex-compiler"
INSTALL_DIR="$HOME/.local/bin"
SCRIPT_URL="https://raw.githubusercontent.com/$REPO/main/bin/lat"

# Colors
BLUE='\033[0;34m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}╔═══════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║            ${CYAN}LAT${NC}${BLUE} Installer                        ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════╝${NC}"
echo ""

# Create install directory
mkdir -p "$INSTALL_DIR"

# Download lat script
echo -e "${CYAN}→${NC} Downloading lat..."
curl -fsSL "$SCRIPT_URL" -o "$INSTALL_DIR/lat"
chmod +x "$INSTALL_DIR/lat"
echo -e "${GREEN}✓${NC} Installed to $INSTALL_DIR/lat"

# Check PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo ""
    echo -e "${YELLOW}!${NC} Add this to your shell config (~/.bashrc or ~/.zshrc):"
    echo ""
    echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
    echo ""
fi

# Ask about installing LaTeX
echo ""
echo -e "${CYAN}→${NC} Would you like to install LaTeX now? (y/n)"
read -r response
if [[ "$response" =~ ^[Yy]$ ]]; then
    echo ""
    "$INSTALL_DIR/lat" install
fi

echo ""
echo -e "${GREEN}✓${NC} Installation complete!"
echo ""
echo "Usage:"
echo "  lat                 # Compile main.tex"
echo "  lat install         # Install LaTeX"
echo "  lat review          # AI review (requires GEMINI_API_KEY)"
echo "  lat -h              # Show help"
