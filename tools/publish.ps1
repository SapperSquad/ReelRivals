# Publish Reel Rivals dist/ zips to Modrinth and CurseForge via their APIs directly.
# No Gradle/Java involved on purpose - this project is pure PowerShell, so this
# script uses .NET's HttpClient (Add-Type -AssemblyName System.Net.Http) the same
# way build.ps1 drops to raw System.IO.Compression instead of Compress-Archive.
#
# ONE-TIME SETUP before this will work:
#   1. Both project ids are baked in below (Modrinth kJZva5Zm, CurseForge 1616194).
#      Do NOT rely on the *_PROJECT_ID env vars: they are user-wide and shared by every
#      mod on this machine, so whichever project published last owns them. Publishing to
#      whatever another project last pointed at is exactly the accident this prevents.
#   2. In a normal terminal (not committed anywhere), set the TOKENS only:
#        setx MODRINTH_TOKEN "mrp_xxxxxxxxxxxxxxxxxxxx"
#        setx CURSEFORGE_TOKEN "xxxxxxxxxxxxxxxxxxxxxx"
#      Open a NEW terminal afterwards so the vars are picked up.
#
# CurseForge is skipped (loudly) when CURSEFORGE_TOKEN is unset, so a Modrinth-only
# publish still works. Pass -CurseForgeProjectId / -ModrinthProjectId for a one-off.
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
    # -JarOnly uploads ONLY the NeoForge datapack-in-jar (for catching it up to an already-published
    # release without duplicating the zip versions). -SkipJar is the inverse.
    [switch]$JarOnly,
    [switch]$SkipJar,
    [switch]$DryRun
)
$ErrorActionPreference = "Stop"

# ---- One-time config: fill these in for your real projects ----
# The version-create endpoint requires the base62 project ID, not the slug (slugs can
# contain hyphens, which aren't valid base62). Confirmed via GET /v2/project/reel-rivals.
$ModrinthProjectId = "kjZva5Zm"           # Reel Rivals' real Modrinth project id

# Reel Rivals' CurseForge project id, baked in for the same reason the Modrinth one
# above is. CURSEFORGE_PROJECT_ID is a USER-WIDE env var shared by every mod on this
# machine, so whichever project published last owns it - reading it means publishing
# wherever some other project happened to point. This is not hypothetical: on
# 2026-08-29 Pantrywork's four jars were aimed at Reel Rivals (1616194) because the
# var still held this project's id, and they failed only because a data-pack project
# rejects the NeoForge loader id. A mod-to-mod mix-up would have gone through.
# Id verified 2026-08-30 against the live project page.
# Resolution order: -CurseForgeProjectId parameter > baked-in id > env var.
$CurseForgeProjectIdDefault = 1616194     # Reel Rivals (Minecraft > Data Packs)
if ($CurseForgeProjectId -eq 0) { $CurseForgeProjectId = $CurseForgeProjectIdDefault }
if ($env:CURSEFORGE_PROJECT_ID -and [int]$env:CURSEFORGE_PROJECT_ID -ne $CurseForgeProjectId) {
    Write-Warning "CURSEFORGE_PROJECT_ID env var is '$($env:CURSEFORGE_PROJECT_ID)' but this script targets '$CurseForgeProjectId' (Reel Rivals) - using the latter."
}
if ($env:MODRINTH_PROJECT_ID -and $env:MODRINTH_PROJECT_ID -ne $ModrinthProjectId) {
    Write-Warning "MODRINTH_PROJECT_ID env var is '$($env:MODRINTH_PROJECT_ID)' but this script targets '$ModrinthProjectId' (Reel Rivals) - using the latter."
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
# The project id is baked in now, so a missing CF token is the only thing that can
# take CurseForge out of the run. Skip loudly rather than throwing - Modrinth-only
# publishes are a real workflow here (1.3.0 shipped that way).
if (-not $SkipCurseForge -and -not $DryRun -and -not $CurseForgeToken) {
    Write-Warning "CURSEFORGE_TOKEN env var is not set - CurseForge will be SKIPPED this run (Modrinth only)."
    $SkipCurseForge = $true
}

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
$script:cfTypeCache = $null

function Get-CurseForgeApi {
    param([string]$Path, [string]$Token)
    $client = New-Object System.Net.Http.HttpClient
    try {
        $client.DefaultRequestHeaders.TryAddWithoutValidation("X-Api-Token", $Token) | Out-Null
        $resp = $client.GetAsync("https://minecraft.curseforge.com/api$Path").GetAwaiter().GetResult()
        $body = $resp.Content.ReadAsStringAsync().GetAwaiter().GetResult()
        if (-not $resp.IsSuccessStatusCode) { throw "GET $Path failed: $($resp.StatusCode) - $body" }
        return $body | ConvertFrom-Json
    } finally {
        $client.Dispose()
    }
}

function Get-CurseForgeGameVersionId {
    param([string]$Name, [string]$Token)
    if (-not $script:cfVersionCache) { $script:cfVersionCache = Get-CurseForgeApi -Path "/game/versions" -Token $Token }
    if (-not $script:cfTypeCache)    { $script:cfTypeCache    = Get-CurseForgeApi -Path "/game/version-types" -Token $Token }

    # A version string exists under SEVERAL gameVersionTypeIDs. Verified 2026-07-19:
    #   "1.21.1" -> 11779 (type 77784 "Minecraft 1.21")  <- the one we want
    #               12735 (type 1, not listed in /game/version-types)
    #               16115 (type 615 "Addons" - the Bukkit taxonomy)
    #   "26.2"   -> 16498 (type 86297 "26.2")            <- the one we want
    # Taking the first match is ORDER-DEPENDENT and would silently tag a release as an
    # Addon if the API ever reordered, so restrict to real Minecraft version groups.
    $mcTypeIds = @($script:cfTypeCache | Where-Object { $_.slug -like "minecraft-*" } | ForEach-Object { $_.id })
    $all   = @($script:cfVersionCache | Where-Object { $_.name -eq $Name -or $_.slug -eq $Name })
    $valid = @($all | Where-Object { $mcTypeIds -contains $_.gameVersionTypeID })

    if ($valid.Count -eq 0) {
        if ($all.Count -gt 0) {
            $seen = ($all | ForEach-Object { $_.gameVersionTypeID }) -join ", "
            Write-Warning "'$Name' exists on CurseForge but only under non-Minecraft version types ($seen). Refusing to guess - skipping."
        } else {
            Write-Warning "No CurseForge game version found matching '$Name' - check the version dropdown on your project's Files page for the exact string CurseForge uses."
        }
        return $null
    }
    if ($valid.Count -gt 1) {
        $ids = ($valid | ForEach-Object { $_.id }) -join ", "
        Write-Warning "'$Name' matched more than one Minecraft version type ($ids); using $($valid[0].id)."
    }
    return $valid[0].id
}

# `mc` = filename suffix; `gv` = the Minecraft versions this ONE artifact is tagged with.
# The 26x tree declares min_format 88 / max_format 107. Verified live on 1.21.10, 1.21.11,
# 26.1.2 and 26.2. 26.1 / 26.1.1 are INFERRED from 26.1.2 (same minor, bracketed by 101 and
# 107) rather than tested - if either is ever reported as not loading, drop it from this list.
$lines = @(
    @{ src = (Join-Path $proj "datapack");     mc = "1.21.1";       gv = @("1.21.1") },
    @{ src = (Join-Path $proj "datapack-26x"); mc = "1.21.10-26.2"; gv = @("1.21.10","1.21.11","26.1","26.1.1","26.1.2","26.2") }
)

# The NeoForge datapack-in-jar (1.21.1 line only, built by build.ps1). Same content as the zip,
# wrapped as a code-free lowcodefml mod so it installs like a mod and always loads after vanilla.
# Uploaded as its OWN Modrinth version under loader "neoforge" - a player's loader filter has to be
# able to find it. Verified end-to-end on a NeoForge dev server 2026-08-09: mod list shows it, the
# fishing loot override applies, and the weigh pipeline runs.
$JarMc = "1.21.1"
$JarPath = Join-Path $dist ("ReelRivals-" + $Version + "+mc" + $JarMc + "-neoforge.jar")

foreach ($l in $lines) {
    if ($JarOnly) { continue }
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
            game_versions  = $l.gv
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
                $gvIds = @()
                foreach ($v in $l.gv) {
                    $id = Get-CurseForgeGameVersionId -Name $v -Token $CurseForgeToken
                    if ($id) { $gvIds += $id; Write-Host "[DryRun]   game version '$v' -> id $id" }
                    else     { Write-Host "[DryRun]   game version '$v' DID NOT RESOLVE - will be omitted" }
                }
                if ($gvIds.Count -gt 0) { Write-Host "[DryRun]   would POST upload-file with $($gvIds.Count) version tag(s)" }
                else { Write-Host "[DryRun]   NO versions resolved - this upload would be skipped" }
            } else {
                Write-Host "[DryRun]   CURSEFORGE_TOKEN not set - cannot verify the game version id"
            }
        } else {
            # Resolve EVERY tag this artifact claims; CurseForge accepts a list.
            $gvIds = @()
            foreach ($v in $l.gv) {
                $id = Get-CurseForgeGameVersionId -Name $v -Token $CurseForgeToken
                if ($id) { $gvIds += $id } else { Write-Warning "CurseForge: version '$v' did not resolve - omitting it." }
            }
            if ($gvIds.Count -eq 0) {
                Write-Warning "Skipping CurseForge upload for $($l.mc) - no matching game version ids."
            } else {
                $metadata = @{
                    changelog     = $changelog
                    changelogType = "markdown"
                    displayName   = "Reel Rivals $Version ($($l.mc))"
                    releaseType   = "release"
                    gameVersions  = $gvIds
                } | ConvertTo-Json -Depth 5

                $headers = @{ "X-Api-Token" = $CurseForgeToken }
                $result = Invoke-MultipartPost -Uri "https://minecraft.curseforge.com/api/projects/$CurseForgeProjectId/upload-file" -Headers $headers -JsonFieldName "metadata" -JsonBody $metadata -FileFieldName "file" -FilePath $zip
                Write-Host "CurseForge: uploaded $($l.mc)"
                Write-Host $result
            }
        }
    }
}

# ---- NeoForge datapack-in-jar (Modrinth only; CurseForge has no Data Pack loader taxonomy) ----
if (-not $SkipModrinth -and -not $SkipJar) {
    if (-not (Test-Path $JarPath)) {
        Write-Host "`nNeoForge jar: SKIPPED - not built. Run build.ps1 -Version $Version first."
    } else {
        Write-Host "`n=== $JarPath ==="
        $jarVersionNumber = "$Version+mc$JarMc-neoforge"
        $jarData = @{
            name           = "Reel Rivals $jarVersionNumber"
            version_number = $jarVersionNumber
            project_id     = $ModrinthProjectId
            file_parts     = @("file")
            primary_file   = "file"
            game_versions  = @($JarMc)
            loaders        = @("neoforge")
            version_type   = "release"
            featured       = $false
            dependencies   = @()
            changelog      = $changelog
        } | ConvertTo-Json -Depth 5

        if ($DryRun) {
            Write-Host "[DryRun] Would POST NeoForge jar to Modrinth /version:"
            Write-Host $jarData
        } else {
            $headers = @{ Authorization = $ModrinthToken }
            $result = Invoke-MultipartPost -Uri "https://api.modrinth.com/v2/version" -Headers $headers -JsonFieldName "data" -JsonBody $jarData -FileFieldName "file" -FilePath $JarPath
            Write-Host "Modrinth: uploaded $jarVersionNumber"
            Write-Host $result
        }
    }
}

Write-Host "`nDone."
