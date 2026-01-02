# 📄 LAT - LaTeX Toolkit

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Release](https://img.shields.io/badge/release-v2.0.0-blue.svg)](https://github.com/Yoannoza/latex-compiler/releases)
[![Build Status](https://img.shields.io/badge/build-passing-brightgreen.svg)](https://github.com/Yoannoza/latex-compiler)

A modern LaTeX development toolkit that brings AI-powered intelligence to your document workflow. Say goodbye to cryptic error messages, manual dependency management, and tedious compilation cycles — LAT automates the boring parts so you can focus on writing.

## ✨ Why LAT?

Traditional LaTeX workflows are powerful but can be frustrating:
- ❌ Cryptic error messages buried in 10,000-line logs
- ❌ Manual dependency installation across different platforms
- ❌ Repetitive compilation cycles for bibliographies and cross-references
- ❌ No intelligent feedback on document quality

**LAT modernizes this workflow:**

| Feature | Description |
|---------|-------------|
| **🚀 Smart Compilation** | Uses `latexmk` for intelligent multi-pass builds with automatic detection of BibTeX, glossaries, and indexes |
| **🤖 AI-Powered Review** | Get instant, context-aware feedback from Gemini 2.5 Flash — no more guessing if your structure makes sense |
| **📦 One-Command Install** | Cross-platform installer handles LaTeX distribution, `latexmk`, and linters automatically |
| **🔍 Intelligent Error Parsing** | Extract and display only the relevant errors — no more scrolling through noise |
| **📁 Clean Workspace** | All auxiliary files go to `build/` — your project directory stays pristine |
| **🖥️ Cross-Platform** | Works seamlessly on Linux, macOS, and Windows with identical commands |

## 📦 Installation

### Linux / macOS

```bash
curl -fsSL https://raw.githubusercontent.com/Yoannoza/latex-compiler/main/install.sh | bash
```

### Windows (PowerShell)

```powershell
irm https://raw.githubusercontent.com/Yoannoza/latex-compiler/main/install.ps1 | iex
```

## 🚀 Quick Start

### Compilation

```bash
lat                    # Compile main.tex (auto-detects BibTeX, glossaries)
lat -f thesis          # Compile thesis.tex
lat -o                 # Compile and open PDF automatically
lat -m                 # Force manual mode (without latexmk)
```

### Document Management

```bash
lat install            # Install LaTeX distribution + dependencies
lat clean              # Remove all build artifacts
lat lint               # Run chktex to check for LaTeX issues
```

### AI-Powered Review

```bash
lat review             # Auto-detect document type and review
lat review -t thesis   # Review with thesis-specific criteria
lat review -t beamer   # Review presentation structure and clarity
lat review -t report   # Review technical report formatting
```

## 🤖 AI Review

LAT integrates **Gemini 2.5 Flash** to provide intelligent, context-aware feedback on your documents. Unlike generic grammar checkers, the AI understands LaTeX document structure and provides actionable recommendations.

### How It Works

1. **Compilation**: LAT compiles your `.tex` file to PDF (ensuring the latest version)
2. **PDF-to-Text Conversion**: The PDF is base64-encoded and sent to Gemini's vision API, which can natively read and understand document layout, formatting, and structure
3. **Context-Aware Analysis**: The AI analyzes your document based on type-specific criteria (thesis rigor, presentation clarity, report professionalism)
4. **Actionable Feedback**: Receive a numbered list of specific, implementable improvements

### Model Details

- **Model**: Gemini 2.5 Flash (via Google AI Studio)
- **Temperature**: 0.4 (balanced between creativity and consistency)
- **Max Tokens**: 2048 (comprehensive feedback)
- **Input**: Native PDF processing (preserves formatting context)

### Setup

1. Get a free API key from [Google AI Studio](https://aistudio.google.com/)
2. Set the environment variable:

```bash
# Linux/macOS
export GEMINI_API_KEY='your-key-here'

# Windows PowerShell
$env:GEMINI_API_KEY = 'your-key-here'

# Make it permanent (Linux/macOS - add to ~/.bashrc or ~/.zshrc)
echo 'export GEMINI_API_KEY="your-key-here"' >> ~/.bashrc
```

### Usage

```bash
lat review              # Auto-detect document type from \documentclass
lat review -t thesis    # Review as thesis (checks depth, citations, formality)
lat review -t beamer    # Review as presentation (checks clarity, density, visuals)
lat review -t report    # Review as technical report (checks structure, professionalism)
lat review -t article   # Review as article (checks general structure and clarity)
```

### Document Type Detection

LAT automatically detects your document type by analyzing the `\documentclass` declaration:
- `thesis` → In-depth academic rigor checks
- `beamer` → Presentation-specific feedback
- `report` → Technical documentation standards
- `article` → General academic writing (default)

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
├── main.tex          # Your LaTeX document
├── references.bib    # Bibliography (optional)
├── figures/          # Images and diagrams (optional)
├── build/            # Temporary compilation files (auto-created, gitignored)
│   ├── main.aux
│   ├── main.log
│   ├── main.out
│   └── ...
└── main.pdf          # Final output (stays in root for easy access)
```

**Pro tip**: Add `build/` to your `.gitignore` to keep your repository clean.

## 🔧 Troubleshooting

### "latexmk not found" Warning

**Problem**: LAT falls back to manual compilation mode, which may miss bibliography/index updates.

**Solution**:
```bash
# Run the installer (installs latexmk + LaTeX)
lat install

# Or install just latexmk:
# Ubuntu/Debian
sudo apt install latexmk

# macOS
brew install latexmk

# Fedora
sudo dnf install latexmk
```

### "GEMINI_API_KEY environment variable not set"

**Problem**: AI review requires a Gemini API key.

**Solution**:
1. Get a free key from [Google AI Studio](https://aistudio.google.com/)
2. Set the variable:
   ```bash
   # Temporary (current session only)
   export GEMINI_API_KEY='your-key-here'
   
   # Permanent (add to ~/.bashrc or ~/.zshrc)
   echo 'export GEMINI_API_KEY="your-key-here"' >> ~/.bashrc
   source ~/.bashrc
   ```

### "pdflatex: command not found"

**Problem**: LaTeX is not installed on your system.

**Solution**:
```bash
lat install    # Installs full LaTeX distribution for your platform
```

### LaTeX Not in PATH (Windows)

**Problem**: After installation, `pdflatex` still not found.

**Solution**:
1. **MiKTeX**: Usually installs to `C:\Program Files\MiKTeX\miktex\bin\x64\`
2. Add to PATH:
   - Open "Environment Variables" in Windows settings
   - Edit "Path" variable
   - Add MiKTeX bin directory
   - Restart terminal

### Compilation Errors

**Problem**: Cryptic errors during compilation.

**Solution**:
1. **Check the log**: LAT extracts key errors, but full details are in `build/main.log`
2. **Run linter**: `lat lint` catches common issues before compilation
3. **Common fixes**:
   - Missing `\end{document}` or `\begin{document}`
   - Unescaped special characters: `% $ & # _ { }`
   - Unclosed braces or environments
   - Missing packages (install with `tlmgr install <package>` or via MiKTeX Console)

### "API Error" During Review

**Problem**: Gemini API returns an error.

**Common causes**:
- Invalid API key → Double-check your key from [Google AI Studio](https://aistudio.google.com/)
- Rate limits → Wait a few seconds and try again (free tier has limits)
- PDF too large → Compress images or reduce document size

## 🗺️ Roadmap

LAT is under active development. Planned features include:

- [ ] **Support for Claude and GPT-4** — Multi-model AI review with provider selection
- [ ] **HTML/Markdown Export** — Convert LaTeX documents to web-friendly formats
- [ ] **Live Preview Mode** — Watch mode with auto-refresh in PDF viewer
- [ ] **Template Gallery** — Scaffolding for thesis, resume, presentation, article templates
- [ ] **Citation Assistant** — AI-powered BibTeX generation from DOI/arXiv/URL
- [ ] **Collaborative Review** — Share review results with teams
- [ ] **VS Code Extension** — Integrated LAT commands in your editor

Want to see something else? [Open an issue](https://github.com/Yoannoza/latex-compiler/issues) with your suggestion!

## 🤝 Contributing

Contributions are welcome! Whether it's bug fixes, new features, documentation improvements, or platform support — we'd love your help.

### How to Contribute

1. **Fork the repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/latex-compiler.git
   cd latex-compiler
   ```

2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes**
   - Follow existing code style (Bash best practices)
   - Test on your platform (Linux/macOS/Windows if possible)
   - Update documentation if adding features

4. **Test thoroughly**
   ```bash
   # Test basic compilation
   ./bin/lat -f test_file
   
   # Test AI review (requires GEMINI_API_KEY)
   ./bin/lat review
   
   # Test installation (optional, may require sudo)
   # ./bin/lat install
   ```

5. **Submit a pull request**
   - Describe your changes clearly
   - Link any related issues
   - Provide examples if adding features

### Areas We Need Help

- **Windows PowerShell script** (`bin/lat.ps1`) — Currently basic, could use feature parity with Bash version
- **Testing infrastructure** — Automated tests for compilation, review, and install
- **Additional AI models** — Integrate Claude, GPT-4, or local models
- **Documentation** — More examples, video tutorials, use cases

### Code of Conduct

Be respectful, constructive, and inclusive. We're here to make LaTeX better for everyone.

## 📄 License

MIT License - see [LICENSE](LICENSE)
