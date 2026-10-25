# Publishes the Sec2SOC announcement page to the PUBLIC GitHub repo LoordKenny/sec2soc-site.
# Everything in this folder becomes public. Never put app code, keys or answer files here.
# Run from PowerShell:
#   cd C:\Users\akino\Projects\sec2soc-site
#   .\publish.ps1

Set-Location -Path $PSScriptRoot

if (-not (Test-Path ".git")) {
    git init
    git branch -M main
    git remote add origin https://github.com/LoordKenny/sec2soc-site.git
}

# Renamed from certcircuit-site to sec2soc-site (Oct 24, 2026): once the GitHub repo is renamed, use the new address.
$origin = git remote get-url origin 2>$null
if ($origin -like "*LoordKenny/certcircuit-site.git") {
    git ls-remote https://github.com/LoordKenny/sec2soc-site.git HEAD *> $null
    if ($LASTEXITCODE -eq 0) {
        git remote set-url origin https://github.com/LoordKenny/sec2soc-site.git
        Write-Host "Publish address updated to LoordKenny/sec2soc-site."
    }
}

if (-not (git config user.name)) { git config user.name "LoordKenny" }
if (-not (git config user.email)) { git config user.email "LoordKenny@users.noreply.github.com" }

git add -A
$stamp = Get-Date -Format "yyyy-MM-dd HH:mm"
if (git status --porcelain) {
    git commit -m "Publish page $stamp" | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Commit failed, so nothing was uploaded." -ForegroundColor Red
        exit 1
    }
    Write-Host "Saved changes ($stamp)."
} else {
    Write-Host "Nothing new to save."
}

git push -u origin main
if ($LASTEXITCODE -ne 0) {
    Write-Host "Upload failed. Check that the PUBLIC repo LoordKenny/sec2soc-site exists on GitHub." -ForegroundColor Red
    exit 1
}
Write-Host "Published: $stamp" -ForegroundColor Green
Write-Host "Page address (after GitHub Pages is turned on): https://loordkenny.github.io/sec2soc-site/"
