# 📄 LAT - LaTeX Toolkit

A complete LaTeX development environment with AI-powered document review.

## ✨ Features

- **🚀 Smart Compilation** - Uses `latexmk` for automatic rebuilds
- **📦 One-Command Install** - Installs LaTeX and all dependencies
- **🤖 AI Review** - Get document feedback from Gemini AI
- **📁 Clean Workspace** - All temp files go to `build/`
- **🔍 Error Parsing** - Shows exactly what went wrong
- **🖥️ Cross-Platform** - Linux, macOS, and Windows

## 📦 Installation

### Linux / macOS

```bash
curl -fsSL https://raw.githubusercontent.com/Yoannoza/latex-compiler/main/install.sh | bash
```

### Windows (PowerShell)

```powershell
irm https://raw.githubusercontent.com/Yoannoza/latex-compiler/main/install.ps1 | iex
```

## 🚀 Commands

```bash
# Compile your document
lat

# Compile a specific file
lat -f thesis

# Compile and open PDF
lat -o

# Install LaTeX on your system
lat install

# Clean build files
lat clean

# Lint your document
lat lint

# AI-powered review
lat review

# AI review with specific document type
lat review -t thesis
```

## 🤖 AI Review

Get intelligent feedback on your LaTeX documents using Gemini AI.

### Setup

1. Get an API key from [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Set the environment variable:

```bash
# Linux/macOS
export GEMINI_API_KEY='your-key-here'

# Windows PowerShell
$env:GEMINI_API_KEY = 'your-key-here'
```

### Usage

```bash
lat review              # Auto-detect document type
lat review -t thesis    # Review as thesis
lat review -t beamer    # Review as presentation
lat review -t report    # Review as report
```

## 📋 Requirements

The `lat install` command will install everything you need:

| Platform | What Gets Installed |
|----------|---------------------|
| Linux (Debian/Ubuntu) | texlive-full, latexmk, chktex |
| Linux (Fedora) | texlive-scheme-full, latexmk, chktex |
| Linux (Arch) | texlive-most, latexmk, chktex |
| macOS | MacTeX, latexmk, chktex |
| Windows | MiKTeX |

## 📁 Project Structure

```
your-project/
├── main.tex          # Your document
├── build/            # Temp files (auto-created)
└── main.pdf          # Output
```

## 📄 License

MIT License - see [LICENSE](LICENSE)
