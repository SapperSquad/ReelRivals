# Transform the 1.21.1 datapack/ tree into datapack-26x/ for Minecraft 26.2 (datapack format 107).
# Mechanical format migration - re-run after any content change to the 1.21.1 source.
# Changes (all empirically verified against a 26.2 server, 2026-07-19):
#   1. pack.mcmeta pack_format 48 -> 107
#   2. loot time_check: "period":24000 -> "clock":"minecraft:overworld"
#   3. recipe ingredients {"item":"X"} -> "X"
#   4. custom_model_data <int> -> {"floats":[<int>]}  (JSON and command-bracket forms)
#   5. enchantments {"levels":{...}} -> {...}  (flat map)
$ErrorActionPreference = "Stop"
$enc = New-Object System.Text.UTF8Encoding($false)
$proj = Split-Path $PSScriptRoot -Parent
$src = Join-Path $proj "datapack"
$dst = Join-Path $proj "datapack-26x"

if (Test-Path $dst) { Get-ChildItem $dst -Recurse -File | Remove-Item -Force }
robocopy $src $dst /MIR /NFL /NDL /NJH /NS /NC | Out-Null

# 1. pack.mcmeta
$mc = '{
  "pack": {
    "pack_format": 107,
    "description": "Reel Rivals - competitive fishing (Minecraft 26.2)"
  }
}'
[System.IO.File]::WriteAllText("$dst\pack.mcmeta", $mc, $enc)

function Transform($relGlob, [scriptblock]$fn) {
  Get-ChildItem (Join-Path $dst $relGlob) -Recurse -File -Filter *.json | ForEach-Object {
    $t = [System.IO.File]::ReadAllText($_.FullName, $enc)
    $new = & $fn $t
    if ($new -ne $t) { [System.IO.File]::WriteAllText($_.FullName, $new, $enc) }
  }
}

# 2. time_check in loot tables
Transform "data\minecraft\loot_table" {
  param($t)
  return ($t -replace '"period":\s*24000', '"clock": "minecraft:overworld"')
}

# 3/4/5. recipes: ingredients, custom_model_data, enchantments
Transform "data\reelrivals\recipe" {
  param($t)
  $t = $t -replace '\{\s*"item":\s*("(?:minecraft|[a-z0-9_]+):[a-z0-9_]+")\s*\}', '$1'
  $t = $t -replace '("minecraft:custom_model_data":\s*)(\d+)', '$1{"floats": [$2]}'
  $t = $t -replace '"minecraft:enchantments":\s*\{\s*"levels":\s*(\{[^}]*\})\s*\}', '"minecraft:enchantments": $1'
  return $t
}

# 4 (command-bracket form) in functions: give/item commands (.mcfunction, incl. macro values)
Get-ChildItem (Join-Path $dst "data\reelrivals\function") -Recurse -File -Filter *.mcfunction | ForEach-Object {
  $t = [System.IO.File]::ReadAllText($_.FullName, $enc)
  # value runs up to the closing ] or , - captures ints and macro forms like 79010$(n)
  $new = $t -replace 'custom_model_data=([0-9$()a-z_]+)', 'custom_model_data={floats:[$1]}'
  if ($new -ne $t) { [System.IO.File]::WriteAllText($_.FullName, $new, $enc) }
}

# 4 (macro data-modify) - lure/apply sets custom_model_data to a bare int via $(cmd)
$applyPath = "$dst\data\reelrivals\function\lure\apply.mcfunction"
if (Test-Path $applyPath) {
  $a = [System.IO.File]::ReadAllText($applyPath, $enc)
  $a = $a -replace '(Item\.components\."minecraft:custom_model_data" set value )\$\(cmd\)', '$1{floats:[$(cmd)]}'
  [System.IO.File]::WriteAllText($applyPath, $a, $enc)
}

# validate all JSON
$bad = @(); Get-ChildItem $dst -Recurse -Filter *.json | ForEach-Object { try { Get-Content $_.FullName -Raw -Encoding UTF8 | ConvertFrom-Json | Out-Null } catch { $bad += $_.Name } }
"ported datapack -> datapack-26x (format 107)"
if ($bad) { "INVALID JSON: $($bad -join ', ')" } else { "all JSON valid" }
