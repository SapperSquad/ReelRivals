# Publish Reel Rivals dist/ zips to Modrinth and CurseForge via their APIs directly.
# No Gradle/Java involved on purpose - this project is pure PowerShell, so this
# script uses .NET's HttpClient (Add-Type -AssemblyName System.Net.Http) the same
# way build.ps1 drops to raw System.IO.Compression instead of Compress-Archive.
#
# ONE-TIME SETUP before this will work:
#   1. $ModrinthProjectId below is already set to Reel Rivals' real project id.
#   2. In a normal terminal (not committed anywhere), set persistent env vars:
#        setx MODRINTH_TOKEN "mrp_xxxxxxxxxxxxxxxxxxxx"
#        setx CURSEFORGE_TOKEN "xxxxxxxxxxxxxxxxxxxxxx"
#        setx CURSEFORGE_PROJECT_ID "123456"    # numeric, from "About Project" on CurseForge
#      Open a NEW terminal afterwards so the vars are picked up.
#
# CurseForge is skipped unless it has a project id (parameter or env var), and the script
# now SAYS so rather than skipping quietly. Modrinth needs no extra setup.
#
# USAGE (run build.ps1 first so dist/ has the zips for -Version):
#   powershell -File tools\publish.ps1 -Version 1.3.0 -ChangelogFile tools\changelog-current.md
#   powershell -File tools\publish.ps1 -Version 1.3.0 -ChangelogFile tools\changelog-current.md -DryRun
#   powershell -File tools\publish.ps1 -Version 1.3.0 -ChangelogFile tools\changelog-current.md -CurseForgeProjectId 123456
#   powershell -File tools\publish.ps1 -Version 1.3.0 -ChangelogFile tools\changelog-current.md -SkipCurseForge
#
# This performs REAL, PUBLIC uploads when run without -DryRun. Review the DryRun
# output first.

param(
    [Parameter(Mandatory=$true)][string]$Version,
    [Parameter(Mandatory=$true)][string]$ChangelogFile,
    [int]$CurseForgeProjectId = 0,
    [switch]$SkipModrinth,
    [switch]$SkipCurseForge,
    [switch]$DryRun
)
$ErrorActionPreference = "Stop"

# ---- One-time config: fill these in for your real projects ----
# The version-create endpoint requires the base62 project ID, not the slug (slugs can
# contain hyphens, which aren't valid base62). Confirmed via GET /v2/project/reel-rivals.
$ModrinthProjectId = "kjZva5Zm"           # Reel Rivals' real Modrinth project id

# CurseForge project id (numeric, from the project's "About Project" sidebar).
# Resolution order: -CurseForgeProjectId parameter > CURSEFORGE_PROJECT_ID env var > unset.
# Set it once with:  setx CURSEFORGE_PROJECT_ID "123456"   (then open a NEW terminal)
if ($CurseForgeProjectId -eq 0 -and $env:CURSEFORGE_PROJECT_ID) {
    $CurseForgeProjectId = [int]$env:CURSEFORGE_PROJECT_ID
}

$proj = Split-Path $PSScriptRoot -Parent
$dist = Join-Path $proj "dist"

if (-not (Test-Path $ChangelogFile)) { throw "Changelog file not found: $ChangelogFile" }
# Get-Content attaches hidden PSPath/PSDrive metadata to the string it returns, which
# ConvertTo-Json then serializes as a nested object instead of a plain string - cast to
# [string] to strip it. -Encoding UTF8 avoids em-dash/quote mojibake on this BOM-less file.
$changelog = [string](Get-Content $ChangelogFile -Raw -Encoding UTF8)

$ModrinthToken = $env:MODRINTH_TOKEN
$CurseForgeToken = $env:CURSEFORGE_TOKEN
if (-not $SkipModrinth -and -not $DryRun -and -not $ModrinthToken) { throw "MODRINTH_TOKEN env var is not set. See the header of this script." }
if (-not $SkipCurseForge -and -not $DryRun -and $CurseForgeProjectId -ne 0 -and -not $CurseForgeToken) { throw "CURSEFORGE_TOKEN env var is not set. See the header of this script." }

Add-Type -AssemblyName System.Net.Http

function Invoke-MultipartPost {
    param([string]$Uri, [hashtable]$Headers, [string]$JsonFieldName, [string]$JsonBody, [string]$FileFieldName, [string]$FilePath)
    $client = New-Object System.Net.Http.HttpClient
    try {
        foreach ($h in $Headers.GetEnumerator()) { $client.DefaultRequestHeaders.TryAddWithoutValidation($h.Key, $h.Value) | Out-Null }
        $content = New-Object System.Net.Http.MultipartFormDataContent

        $jsonContent = New-Object System.Net.Http.StringContent($JsonBody, [System.Text.Encoding]::UTF8, "application/json")
        $content.Add($jsonContent, $JsonFieldName)

        $fileBytes = [System.IO.File]::ReadAllBytes($FilePath)
        $fileContent = New-Object System.Net.Http.ByteArrayContent(, $fileBytes)
        $fileContent.Headers.ContentType = New-Object System.Net.Http.Headers.MediaTypeHeaderValue("application/zip")
        $content.Add($fileContent, $FileFieldName, [System.IO.Path]::GetFileName($FilePath))

        $response = $client.PostAsync($Uri, $content).GetAwaiter().GetResult()
        $body = $response.Content.ReadAsStringAsync().GetAwaiter().GetResult()
        if (-not $response.IsSuccessStatusCode) {
            throw "$Uri failed: $($response.StatusCode) - $body"
        }
        return $body
    } finally {
        $client.Dispose()
    }
}

$script:cfVersionCache = $null
function Get-CurseForgeGameVersionId {
    param([string]$Name, [string]$Token)
    if (-not $script:cfVersionCache) {
        $client = New-Object System.Net.Http.HttpClient
        try {
            $client.DefaultRequestHeaders.TryAddWithoutValidation("X-Api-Token", $Token) | Out-Null
            $resp = $client.GetAsync("https://minecraft.curseforge.com/api/game/versions").GetAwaiter().GetResult()
            $body = $resp.Content.ReadAsStringAsync().GetAwaiter().GetResult()
            if (-not $resp.IsSuccessStatusCode) { throw "Fetching CurseForge game versions failed: $($resp.StatusCode) - $body" }
            $script:cfVersionCache = $body | ConvertFrom-Json
        } finally {
            $client.Dispose()
        }
    }
    $match = $script:cfVersionCache | Where-Object { $_.name -eq $Name -or $_.slug -eq $Name }
    if (-not $match) {
        Write-Warning "No CurseForge game version found matching '$Name' - check the version dropdown on your CurseForge project's Files page for the exact string CurseForge uses."
        return $null
    }
    return ($match | Select-Object -First 1).id
}

$lines = @(
    @{ src = (Join-Path $proj "datapack");     mc = "1.21.1" },
    @{ src = (Join-Path $proj "datapack-26x"); mc = "26.2" }
)

foreach ($l in $lines) {
    $zip = Join-Path $dist ("ReelRivals-" + $Version + "+mc" + $l.mc + ".zip")
    if (-not (Test-Path $zip)) { continue }
    Write-Host "`n=== $zip ==="

    if (-not $SkipModrinth) {
        $versionNumber = "$Version+mc$($l.mc)"
        $data = @{
            name           = "Reel Rivals $versionNumber"
            version_number = $versionNumber
            project_id     = $ModrinthProjectId
            file_parts     = @("file")
            primary_file   = "file"
            game_versions  = @($l.mc)
            loaders        = @("datapack")
            version_type   = "release"
            featured       = $false
            dependencies   = @()
            changelog      = $changelog
        } | ConvertTo-Json -Depth 5

        if ($DryRun) {
            Write-Host "[DryRun] Would POST to Modrinth /version:"
            Write-Host $data
        } else {
            $headers = @{ Authorization = $ModrinthToken }
            $result = Invoke-MultipartPost -Uri "https://api.modrinth.com/v2/version" -Headers $headers -JsonFieldName "data" -JsonBody $data -FileFieldName "file" -FilePath $zip
            Write-Host "Modrinth: uploaded $versionNumber"
            Write-Host $result
        }
    }

    # Say so out loud when CurseForge is being skipped. A silent skip reads as a successful
    # two-platform publish when only Modrinth actually got the file.
    if ($SkipCurseForge) {
        Write-Host "CurseForge: SKIPPED (-SkipCurseForge)"
    } elseif ($CurseForgeProjectId -eq 0) {
        Write-Host "CurseForge: SKIPPED - no project id. Pass -CurseForgeProjectId <number> or set CURSEFORGE_PROJECT_ID."
    }

    if (-not $SkipCurseForge -and $CurseForgeProjectId -ne 0) {
        if ($DryRun) {
            # Resolve the game version for real - it is a read-only GET, and an unresolvable
            # version is the most common reason a CurseForge upload fails. Better to find out
            # in the dry run than half way through a live publish.
            Write-Host "[DryRun] CurseForge project $CurseForgeProjectId"
            if ($CurseForgeToken) {
                $gvId = Get-CurseForgeGameVersionId -Name $l.mc -Token $CurseForgeToken
                if ($gvId) {
                    Write-Host "[DryRun]   game version '$($l.mc)' -> id $gvId; would POST upload-file"
                } else {
                    Write-Host "[DryRun]   game version '$($l.mc)' DID NOT RESOLVE - this upload would be skipped"
                }
            } else {
                Write-Host "[DryRun]   CURSEFORGE_TOKEN not set - cannot verify the game version id"
            }
        } else {
            $gvId = Get-CurseForgeGameVersionId -Name $l.mc -Token $CurseForgeToken
            if (-not $gvId) {
                Write-Warning "Skipping CurseForge upload for $($l.mc) - no matching game version id."
            } else {
                $metadata = @{
                    changelog     = $changelog
                    changelogType = "markdown"
                    displayName   = "Reel Rivals $Version ($($l.mc))"
                    releaseType   = "release"
                    gameVersions  = @($gvId)
                } | ConvertTo-Json -Depth 5

                $headers = @{ "X-Api-Token" = $CurseForgeToken }
                $result = Invoke-MultipartPost -Uri "https://minecraft.curseforge.com/api/projects/$CurseForgeProjectId/upload-file" -Headers $headers -JsonFieldName "metadata" -JsonBody $metadata -FileFieldName "file" -FilePath $zip
                Write-Host "CurseForge: uploaded $($l.mc)"
                Write-Host $result
            }
        }
    }
}

Write-Host "`nDone."
