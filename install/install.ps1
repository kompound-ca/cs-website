# CS2 GenCode — one-line installer
# Source (verify before running):
#   https://github.com/kompound-ca/cs-website/blob/main/install/install.ps1
#
# What this does:
#   1. Downloads cs2-gencode-1.0.0.crx (the signed extension package)
#   2. Saves it to your Downloads folder
#   3. Opens that folder in Explorer with the .crx selected
#   4. Opens chrome://extensions/ in Chrome
#
# What you do:
#   5. Toggle "Developer mode" on (top-right switch on chrome://extensions)
#   6. Drag the .crx from Explorer onto the chrome://extensions tab
#   7. Click "Add extension" on the confirmation dialog
#   8. Turn Developer mode OFF again — the extension stays installed
#
# Nothing here writes to the registry, modifies system files, requires
# admin rights, or runs in the background. Read it before you run it.

$ErrorActionPreference = 'Stop'

$CrxUrl     = 'https://cs2inspect.dghq.app/cs2-gencode-1.0.0.crx'
$Downloads  = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path
if (-not $Downloads) { $Downloads = Join-Path $env:USERPROFILE 'Downloads' }
$CrxFile    = Join-Path $Downloads 'cs2-gencode-1.0.0.crx'

function Step($n, $msg) {
    Write-Host "[$n/4] " -NoNewline -ForegroundColor Cyan
    Write-Host $msg
}

Write-Host ''
Write-Host '  CS2 GenCode installer' -ForegroundColor Magenta
Write-Host '  ---------------------' -ForegroundColor DarkGray
Write-Host ''

# 1. Download
Step 1 "Downloading $CrxUrl"
try {
    $progressBefore = $ProgressPreference
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri $CrxUrl -OutFile $CrxFile -UseBasicParsing
    $ProgressPreference = $progressBefore
} catch {
    Write-Host "  ! Download failed: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
$size = [math]::Round((Get-Item $CrxFile).Length / 1KB, 1)
Write-Host "      saved to $CrxFile ($size KB)" -ForegroundColor DarkGray

# 2. Open Explorer with the CRX selected
Step 2 'Opening Downloads folder with the .crx selected'
Start-Process explorer.exe -ArgumentList "/select,`"$CrxFile`""

# 3. Locate Chrome and open chrome://extensions/
Step 3 'Opening chrome://extensions/'
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
    Write-Host '  ! Chrome not found in the usual locations.' -ForegroundColor Yellow
    Write-Host '    Open Chrome yourself and navigate to chrome://extensions/' -ForegroundColor Yellow
}

# 4. Print final instructions
Step 4 'Done. Three clicks left in Chrome:'
Write-Host ''
Write-Host '   1. Toggle ' -NoNewline
Write-Host 'Developer mode' -ForegroundColor Yellow -NoNewline
Write-Host ' ON (switch in the top-right corner).'
Write-Host '   2. Drag ' -NoNewline
Write-Host 'cs2-gencode-1.0.0.crx' -ForegroundColor Yellow -NoNewline
Write-Host ' from the Explorer window onto the Chrome tab.'
Write-Host '   3. Click ' -NoNewline
Write-Host 'Add extension' -ForegroundColor Yellow -NoNewline
Write-Host ' on the confirmation dialog.'
Write-Host ''
Write-Host '   Optional: turn Developer mode OFF after install — the extension keeps' -ForegroundColor DarkGray
Write-Host '   working and Chrome stops showing the dev-mode warning popup on launch.' -ForegroundColor DarkGray
Write-Host ''
Write-Host '   Pin the icon from the puzzle-piece menu to keep it visible in the toolbar.' -ForegroundColor DarkGray
Write-Host ''
