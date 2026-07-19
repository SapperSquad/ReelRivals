# Build Reel Rivals release zips into dist/
# Usage: powershell -File build.ps1 [-Version 1.0.0]
# Each Minecraft line builds from its own source tree:
#   datapack/      -> +mc1.21.1  (stable line)
#   datapack-26x/  -> +mc26.2    (built only if the folder exists)
param([string]$Version = "1.0.0")
$ErrorActionPreference = "Stop"
$proj = Split-Path $PSScriptRoot -Parent
$dist = Join-Path $proj "dist"
New-Item -ItemType Directory -Force $dist | Out-Null

$lines = @(
  @{ src = (Join-Path $proj "datapack");     mc = "1.21.1" },
  @{ src = (Join-Path $proj "datapack-26x"); mc = "26.2" }
)
foreach ($l in $lines) {
  if (-not (Test-Path (Join-Path $l.src "pack.mcmeta"))) { continue }
  $zip = Join-Path $dist ("ReelRivals-" + $Version + "+mc" + $l.mc + ".zip")
  if (Test-Path $zip) { Remove-Item $zip -Force -Confirm:$false }
  # Zip the CONTENTS so pack.mcmeta sits at the zip root, using FORWARD-SLASH entry
  # names. (PS 5.1 Compress-Archive writes backslash entries, which Minecraft's zip
  # reader treats as literal filename chars -> the pack enables but loads empty.)
  Add-Type -AssemblyName System.IO.Compression | Out-Null
  Add-Type -AssemblyName System.IO.Compression.FileSystem | Out-Null
  $fsOut = [System.IO.File]::Create($zip)
  $za = New-Object System.IO.Compression.ZipArchive($fsOut, [System.IO.Compression.ZipArchiveMode]::Create)
  Get-ChildItem $l.src -Recurse -File | ForEach-Object {
    $rel = $_.FullName.Substring($l.src.Length + 1).Replace("\", "/")
    $entry = $za.CreateEntry($rel)
    $es = $entry.Open(); $inS = [System.IO.File]::OpenRead($_.FullName); $inS.CopyTo($es); $inS.Dispose(); $es.Dispose()
  }
  $za.Dispose(); $fsOut.Dispose()
  $mb = [math]::Round((Get-Item $zip).Length / 1KB, 0)
  "built: $zip ($mb KB)"
}
"Upload each zip as its own version on the Modrinth project, tagging its game version."
