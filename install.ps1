# =====================================================================
# LAT Installer - Windows PowerShell
# =====================================================================
# Usage: irm https://raw.githubusercontent.com/Yoannoza/latex-compiler/main/install.ps1 | iex
# =====================================================================

$ErrorActionPreference = "Stop"

$REPO = "Yoannoza/latex-compiler"
$INSTALL_DIR = "$HOME\.local\bin"
$SCRIPT_URL = "https://raw.githubusercontent.com/$REPO/main/bin/lat.ps1"

Write-Host "╔═══════════════════════════════════════════════╗" -ForegroundColor Blue
Write-Host "║            " -NoNewline -ForegroundColor Blue
Write-Host "LAT" -NoNewline -ForegroundColor Cyan
Write-Host " Installer                        ║" -ForegroundColor Blue
Write-Host "╚═══════════════════════════════════════════════╝" -ForegroundColor Blue
Write-Host ""

# Create install directory
New-Item -ItemType Directory -Path $INSTALL_DIR -Force | Out-Null

# Download lat.ps1
Write-Host "→ Downloading lat.ps1..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $SCRIPT_URL -OutFile "$INSTALL_DIR\lat.ps1"
Write-Host "✓ Installed to $INSTALL_DIR\lat.ps1" -ForegroundColor Green

# Create wrapper batch file
$wrapperContent = @"
@echo off
powershell -ExecutionPolicy Bypass -File "%USERPROFILE%\.local\bin\lat.ps1" %*
"@
Set-Content -Path "$INSTALL_DIR\lat.cmd" -Value $wrapperContent
Write-Host "✓ Created lat.cmd wrapper" -ForegroundColor Green

# Update PATH
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($userPath -notlike "*$INSTALL_DIR*") {
    Write-Host ""
    Write-Host "! Adding $INSTALL_DIR to PATH..." -ForegroundColor Yellow
    [Environment]::SetEnvironmentVariable("Path", "$userPath;$INSTALL_DIR", "User")
    Write-Host "✓ PATH updated (restart your terminal)" -ForegroundColor Green
}

# Ask about installing LaTeX
Write-Host ""
$response = Read-Host "→ Would you like to install LaTeX now? (y/n)"
if ($response -match "^[Yy]$") {
    Write-Host ""
    & "$INSTALL_DIR\lat.ps1" install
}

Write-Host ""
Write-Host "✓ Installation complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Usage:"
Write-Host "  lat                 # Compile main.tex"
Write-Host "  lat install         # Install LaTeX"
Write-Host "  lat review          # AI review (requires GEMINI_API_KEY)"
Write-Host "  lat -h              # Show help"
