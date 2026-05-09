# CS2 GenCode one-line installer
# Source (verify before running):
#   https://github.com/kompound-ca/cs-website/blob/main/install/install.ps1
#
# What this does:
#   1. Downloads cs2-gencode-1.0.2.zip
#   2. Extracts it to %LOCALAPPDATA%\cs2-gencode (persistent, Chrome reads from it on every launch)
#   3. Copies that folder path to your clipboard
#   4. Opens that folder in Explorer
#   5. Opens chrome://extensions/ in Chrome
#
# What you do:
#   6. Toggle "Developer mode" ON (top-right switch on chrome://extensions)
#   7. Click "Load unpacked" and paste the path from your clipboard
#
# Nothing here writes to the registry, modifies system files, requires
# admin rights, or runs in the background. Read it before you run it.

$ErrorActionPreference = 'Stop'

$ZipUrl     = 'https://cs2inspect.dghq.app/cs2-gencode-1.0.2.zip'
$InstallDir = Join-Path $env:LOCALAPPDATA 'cs2-gencode'
$TempZip    = Join-Path $env:TEMP 'cs2-gencode-install.zip'

function Step($n, $msg) {
    Write-Host "[$n/5] " -NoNewline -ForegroundColor Cyan
    Write-Host $msg
}

Write-Host ''
Write-Host '  CS2 GenCode installer' -ForegroundColor Magenta
Write-Host '  ---------------------' -ForegroundColor DarkGray
Write-Host ''

# 1. Download
Step 1 "Downloading $ZipUrl"
try {
    $progressBefore = $ProgressPreference
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri $ZipUrl -OutFile $TempZip -UseBasicParsing
    $ProgressPreference = $progressBefore
} catch {
    Write-Host "  Download failed: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
$size = [math]::Round((Get-Item $TempZip).Length / 1KB, 1)
Write-Host "      $size KB downloaded" -ForegroundColor DarkGray

# 2. Clean previous install
if (Test-Path $InstallDir) {
    Step 2 "Replacing previous install at $InstallDir"
    Remove-Item -Recurse -Force $InstallDir
} else {
    Step 2 "Preparing install location"
}
New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null

# 3. Extract
Step 3 "Extracting to $InstallDir"
Expand-Archive -Path $TempZip -DestinationPath $InstallDir -Force
Remove-Item $TempZip -Force

# Some zip extractors nest contents inside an extra folder. Flatten if so.
$manifest = Join-Path $InstallDir 'manifest.json'
if (-not (Test-Path $manifest)) {
    $children = Get-ChildItem -Path $InstallDir -Force
    $subdirs  = $children | Where-Object { $_.PSIsContainer }
    if ($subdirs.Count -eq 1 -and $children.Count -eq 1) {
        $inner = $subdirs[0].FullName
        Get-ChildItem -Path $inner -Force | Move-Item -Destination $InstallDir -Force
        Remove-Item $inner -Recurse -Force
    }
}

if (-not (Test-Path $manifest)) {
    Write-Host "  manifest.json not found after extraction." -ForegroundColor Red
    Write-Host "    Open $InstallDir manually and check the contents." -ForegroundColor Red
    exit 1
}

# 4. Copy path to clipboard + open Explorer to it
Step 4 'Copying install folder path to clipboard'
Set-Clipboard -Value $InstallDir
Start-Process explorer.exe -ArgumentList "`"$InstallDir`""

# 5. Open chrome://extensions/
Step 5 'Opening chrome://extensions/'
$chrome = $null
foreach ($candidate in @(
    "$env:ProgramFiles\Google\Chrome\Application\chrome.exe",
    "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe",
    "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe"
)) {
    if (Test-Path $candidate) { $chrome = $candidate; break }
}
if ($chrome) {
    Start-Process -FilePath $chrome -ArgumentList 'chrome://extensions/'
} else {
    Write-Host '  Chrome not found in the usual locations.' -ForegroundColor Yellow
    Write-Host '    Open Chrome yourself and navigate to chrome://extensions/' -ForegroundColor Yellow
}

Write-Host ''
Write-Host '  Done. Two clicks left in Chrome:' -ForegroundColor Green
Write-Host ''
Write-Host '    1. Toggle ' -NoNewline
Write-Host 'Developer mode' -ForegroundColor Yellow -NoNewline
Write-Host ' ON (switch in the top-right corner).'
Write-Host '    2. Click ' -NoNewline
Write-Host 'Load unpacked' -ForegroundColor Yellow -NoNewline
Write-Host ' and paste the path from your clipboard:'
Write-Host ''
Write-Host "       $InstallDir" -ForegroundColor White
Write-Host ''
Write-Host '  Pin the icon from the puzzle-piece menu so it stays visible.' -ForegroundColor DarkGray
Write-Host ''
