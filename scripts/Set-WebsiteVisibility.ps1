param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("public", "hidden")]
    [string]$Mode,

    [switch]$Deploy
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $PSScriptRoot
$configPath = Join-Path $repoRoot "_config.yml"

if (-not (Test-Path -LiteralPath $configPath)) {
    throw "Cannot find _config.yml at $configPath"
}

$content = [System.IO.File]::ReadAllText($configPath)
$newLine = "website_visibility       : `"$Mode`""

if ($content -match "(?m)^website_visibility\s*:") {
    $content = [regex]::Replace($content, "(?m)^website_visibility\s*:.*$", $newLine)
} else {
    $baseUrlPattern = [regex]"(?m)^(baseurl\s*:.*)$"
    $content = $baseUrlPattern.Replace($content, "`$1`r`n$newLine", 1)
}

if (-not $content.EndsWith("`n")) {
    $content += "`r`n"
}

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($configPath, $content, $utf8NoBom)

Write-Host "Website visibility set to '$Mode'."

if (-not $Deploy) {
    Write-Host "Local config changed only. Commit and push when ready."
    exit 0
}

function Invoke-Git {
    param([string[]]$GitArgs)
    & git -C $repoRoot @GitArgs
    if ($LASTEXITCODE -ne 0) {
        throw "git $($GitArgs -join ' ') failed"
    }
}

Invoke-Git @("add", "_config.yml")
& git -C $repoRoot diff --cached --quiet -- "_config.yml"
$diffExit = $LASTEXITCODE

if ($diffExit -eq 0) {
    Write-Host "No deployment commit needed; website is already '$Mode'."
    exit 0
}

if ($diffExit -ne 1) {
    throw "Unable to inspect staged config change."
}

Invoke-Git @("commit", "-m", "Set website visibility to $Mode")
Invoke-Git @("push", "origin", "main")

Write-Host "Done. GitHub Pages will update after the deployment build finishes."
