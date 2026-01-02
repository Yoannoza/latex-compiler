# =====================================================================
# LAT - Modern LaTeX Toolkit (Windows PowerShell)
# =====================================================================
# A complete LaTeX development environment with AI-powered review.
# https://github.com/Yoannoza/latex-compiler
# =====================================================================

param(
    [Parameter(Position=0)]
    [string]$Command = "compile",
    
    [Alias("f")]
    [string]$File = "main",
    
    [Alias("o")]
    [switch]$Open,
    
    [Alias("t")]
    [string]$Type = "",
    
    [Alias("m")]
    [switch]$Manual,
    
    [Alias("h")]
    [switch]$Help,
    
    [Alias("v")]
    [switch]$Version
)

$ErrorActionPreference = "Stop"

# Configuration
$MAIN_FILE = $File -replace '\.tex$', ''
$BUILD_DIR = "build"
$LOG_FILE = "compilation.log"
$USE_LATEXMK = -not $Manual

# =====================================================================
# UI
# =====================================================================

function Write-Header {
    Write-Host "╔═══════════════════════════════════════════════╗" -ForegroundColor Blue
    Write-Host "║            " -NoNewline -ForegroundColor Blue
    Write-Host "LAT" -NoNewline -ForegroundColor Cyan
    Write-Host " - LaTeX Toolkit                 ║" -ForegroundColor Blue
    Write-Host "╚═══════════════════════════════════════════════╝" -ForegroundColor Blue
    Write-Host ""
}

function Write-Step { param($msg) Write-Host "→ $msg" -ForegroundColor Cyan }
function Write-Success { param($msg) Write-Host "✓ $msg" -ForegroundColor Green }
function Write-Error { param($msg) Write-Host "✗ $msg" -ForegroundColor Red }
function Write-Warning { param($msg) Write-Host "! $msg" -ForegroundColor Yellow }
function Write-Info { param($msg) Write-Host "ℹ $msg" -ForegroundColor Magenta }

# =====================================================================
# UTILITIES
# =====================================================================

function Test-Dependencies {
    $missing = @()
    
    if (-not (Get-Command pdflatex -ErrorAction SilentlyContinue)) {
        $missing += "pdflatex"
    }
    
    if ($USE_LATEXMK) {
        if (-not (Get-Command latexmk -ErrorAction SilentlyContinue)) {
            Write-Warning "latexmk not found, using manual mode"
            $script:USE_LATEXMK = $false
        }
    }
    
    if ($missing.Count -gt 0) {
        Write-Error "Missing: $($missing -join ', ')"
        Write-Host ""
        Write-Host "Run 'lat install' to install LaTeX on your system."
        exit 1
    }
}

function Get-DocumentType {
    param($FilePath)
    $content = Get-Content $FilePath -Raw -ErrorAction SilentlyContinue
    if ($content -match '\\documentclass.*\{thesis\}') { return "thesis" }
    if ($content -match '\\documentclass.*\{beamer\}') { return "beamer" }
    if ($content -match '\\documentclass.*\{report\}') { return "report" }
    return "article"
}

function Get-Errors {
    $log = Join-Path $BUILD_DIR "$MAIN_FILE.log"
    if (Test-Path $log) {
        Write-Host ""
        Write-Info "Errors found:"
        Get-Content $log | Select-String "^!" -Context 0,2 | Select-Object -First 10
    }
}

# =====================================================================
# ACTIONS
# =====================================================================

function Install-LaTeX {
    Write-Step "Installing LaTeX on Windows..."
    
    # Try winget first
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        Write-Step "Using winget..."
        & winget install MiKTeX.MiKTeX --accept-package-agreements --accept-source-agreements
    }
    # Fallback to chocolatey
    elseif (Get-Command choco -ErrorAction SilentlyContinue) {
        Write-Step "Using Chocolatey..."
        & choco install miktex -y
    }
    else {
        Write-Error "Neither winget nor chocolatey found"
        Write-Host ""
        Write-Host "Install MiKTeX manually from: https://miktex.org/download"
        exit 1
    }
    
    Write-Success "LaTeX installation complete!"
    Write-Info "You may need to restart your terminal"
}

function Invoke-Clean {
    Write-Step "Cleaning..."
    Remove-Item -Path $BUILD_DIR -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "*.pdf" -Force -ErrorAction SilentlyContinue
    Remove-Item -Path $LOG_FILE -Force -ErrorAction SilentlyContinue
    Write-Success "Clean complete"
}

function Invoke-Lint {
    Write-Step "Linting $MAIN_FILE.tex..."
    if (Get-Command chktex -ErrorAction SilentlyContinue) {
        & chktex -q "$MAIN_FILE.tex"
        Write-Success "Lint complete"
    } else {
        Write-Error "chktex not installed"
        exit 1
    }
}

function Invoke-LatexMk {
    Write-Step "Compiling with latexmk..."
    New-Item -ItemType Directory -Path $BUILD_DIR -Force | Out-Null
    
    & latexmk -pdf -interaction=nonstopmode `
              -output-directory="$BUILD_DIR" `
              "$MAIN_FILE.tex" 2>&1 | Out-File $LOG_FILE
    
    if ($LASTEXITCODE -eq 0) {
        Copy-Item "$BUILD_DIR\$MAIN_FILE.pdf" . -Force
        return $true
    }
    return $false
}

function Invoke-Manual {
    Write-Step "Compiling (manual mode)..."
    New-Item -ItemType Directory -Path $BUILD_DIR -Force | Out-Null
    
    $opts = "-interaction=nonstopmode", "-output-directory=$BUILD_DIR"
    
    & pdflatex @opts "$MAIN_FILE.tex" 2>&1 | Out-File $LOG_FILE -Append
    
    if (Test-Path "$BUILD_DIR\$MAIN_FILE.aux") {
        & bibtex "$BUILD_DIR\$MAIN_FILE" 2>&1 | Out-File $LOG_FILE -Append
    }
    
    & pdflatex @opts "$MAIN_FILE.tex" 2>&1 | Out-File $LOG_FILE -Append
    & pdflatex @opts "$MAIN_FILE.tex" 2>&1 | Out-File $LOG_FILE -Append
    
    if (Test-Path "$BUILD_DIR\$MAIN_FILE.pdf") {
        Copy-Item "$BUILD_DIR\$MAIN_FILE.pdf" . -Force
        return $true
    }
    return $false
}

function Open-Pdf {
    if (Test-Path "$MAIN_FILE.pdf") {
        Write-Info "Opening $MAIN_FILE.pdf..."
        Start-Process "$MAIN_FILE.pdf"
    }
}

# =====================================================================
# AI REVIEW
# =====================================================================

function Invoke-Review {
    param($DocType)
    
    $apiKey = $env:GEMINI_API_KEY
    if (-not $apiKey) {
        Write-Error "GEMINI_API_KEY environment variable not set"
        Write-Host ""
        Write-Host "Get your API key from: https://makersuite.google.com/app/apikey"
        Write-Host 'Then run: $env:GEMINI_API_KEY = "your-key-here"'
        exit 1
    }
    
    if (-not (Test-Path "$MAIN_FILE.tex")) {
        Write-Error "File $MAIN_FILE.tex not found"
        exit 1
    }
    
    # Auto-detect document type
    if (-not $DocType) {
        $DocType = Get-DocumentType "$MAIN_FILE.tex"
    }
    
    Write-Step "Analyzing $MAIN_FILE.tex as '$DocType'..."
    
    $content = Get-Content "$MAIN_FILE.tex" -Raw
    
    # Create prompt based on type
    $prompt = switch ($DocType) {
        "thesis" { "You are a LaTeX expert. Review this thesis for structure, citations, and academic tone. Be concise, use a numbered list." }
        "beamer" { "You are a LaTeX expert. Review this presentation for slide density, visual clarity, and flow. Be concise, use a numbered list." }
        "report" { "You are a LaTeX expert. Review this report for structure, clarity, and formatting. Be concise, use a numbered list." }
        default { "You are a LaTeX expert. Review this document for structure, clarity, and LaTeX best practices. Be concise, use a numbered list." }
    }
    
    $body = @{
        contents = @(@{
            parts = @(
                @{ text = $prompt },
                @{ text = "Document to review:`n`n$content" }
            )
        })
        generationConfig = @{
            temperature = 0.7
            maxOutputTokens = 2048
        }
    } | ConvertTo-Json -Depth 10
    
    try {
        $response = Invoke-RestMethod -Uri "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apiKey" `
            -Method Post -Body $body -ContentType "application/json"
        
        Write-Host ""
        Write-Host "═══════════════════════════════════════════════" -ForegroundColor Cyan
        Write-Host "  AI Review - Document Type: $DocType" -ForegroundColor Yellow
        Write-Host "═══════════════════════════════════════════════" -ForegroundColor Cyan
        Write-Host ""
        
        $response.candidates[0].content.parts[0].text
        
        Write-Host ""
        Write-Success "Review complete"
    }
    catch {
        Write-Error "API Error: $_"
        exit 1
    }
}

# =====================================================================
# MAIN
# =====================================================================

function Show-Help {
    Write-Host "Usage: lat [COMMAND] [OPTIONS]"
    Write-Host ""
    Write-Host "Commands:"
    Write-Host "  (default)       Compile the document"
    Write-Host "  install         Install LaTeX on your system"
    Write-Host "  clean           Remove build artifacts"
    Write-Host "  lint            Check for LaTeX errors"
    Write-Host "  review          AI-powered document review"
    Write-Host ""
    Write-Host "Options:"
    Write-Host "  -f, -File NAME    Set main file (default: main.tex)"
    Write-Host "  -o, -Open         Open PDF after build"
    Write-Host "  -t, -Type TYPE    Document type for review"
    Write-Host "  -m, -Manual       Force manual mode"
    Write-Host "  -h, -Help         Show this help"
}

function Show-Version { Write-Host "lat v2.0.0" }

# Entry point
if ($Help) { Show-Help; exit 0 }
if ($Version) { Show-Version; exit 0 }

Write-Header

switch ($Command) {
    "install" { Install-LaTeX }
    "clean" { Invoke-Clean }
    "lint" {
        if (-not (Test-Path "$MAIN_FILE.tex")) {
            Write-Error "File $MAIN_FILE.tex not found"
            exit 1
        }
        Invoke-Lint
    }
    "review" { Invoke-Review -DocType $Type }
    { $_ -in @("compile", "full", "") } {
        Test-Dependencies
        
        if (-not (Test-Path "$MAIN_FILE.tex")) {
            Write-Error "File $MAIN_FILE.tex not found"
            exit 1
        }
        
        "=== $(Get-Date) ===" | Out-File $LOG_FILE
        
        $success = if ($USE_LATEXMK) { Invoke-LatexMk } else { Invoke-Manual }
        
        if ($success) {
            Write-Success "Build complete: $MAIN_FILE.pdf"
            if ($Open) { Open-Pdf }
        } else {
            Write-Error "Build failed"
            Get-Errors
            exit 1
        }
    }
    default {
        Write-Error "Unknown command: $Command"
        Show-Help
        exit 1
    }
}
