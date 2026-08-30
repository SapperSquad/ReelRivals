# Transform the 1.21.1 datapack/ tree into datapack-26x/ for Minecraft 26.2 (datapack format 107).
# Mechanical format migration - re-run after any content change to the 1.21.1 source.
# Changes (all empirically verified against a 26.2 server, 2026-07-19):
#   1. pack.mcmeta pack_format 48 -> 107
#   2. loot time_check: "period":24000 -> "clock":"minecraft:overworld"
#   3. recipe ingredients {"item":"X"} -> "X"
#   4. custom_model_data <int> -> {"floats":[<int>]}  (JSON and command-bracket forms)
#   5. enchantments {"levels":{...}} -> {...}  (flat map)
#   6. loot set_custom_model_data "value":<int> -> "floats":{mode,values} (scalar silently no-ops)
$ErrorActionPreference = "Stop"
$enc = New-Object System.Text.UTF8Encoding($false)
$proj = Split-Path $PSScriptRoot -Parent
$src = Join-Path $proj "datapack"
$dst = Join-Path $proj "datapack-26x"

if (Test-Path $dst) { Get-ChildItem $dst -Recurse -File | Remove-Item -Force }
robocopy $src $dst /MIR /NFL /NDL /NJH /NS /NC | Out-Null

# 1. pack.mcmeta
# Declares a RANGE, not a single version. The same content payload was verified live on
# data formats 88 (1.21.10), 94 (1.21.11) and 101 (26.1.2), with 107 (26.2) as its native
# target - see CLAUDE.md "Multi-version findings". min_format/max_format are MANDATORY for
# anything above format 81; supported_formats alone is rejected there.
$mc = '{
  "pack": {
    "description": "Reel Rivals - competitive fishing (MC 1.21.10 - 26.2)",
    "min_format": 88,
    "max_format": 107
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

# 2b. loot-table set_custom_model_data: scalar "value" -> floats list-operation object.
# The 1.21.1 form { "function": "minecraft:set_custom_model_data", "value": 790002 } still PARSES
# on 26.x/1.21.11 but silently yields an EMPTY component ({}), so every fish lost its model id and
# a resource pack could not re-skin them. Verified empirically on a 1.21.11 server 2026-08-09:
#   "floats":[790002]                                  -> table fails to parse
#   "floats":{"mode":"replace_all","values":[790002]}   -> {floats:[790002.0f]}   CORRECT
#   "value":790002                                     -> {}                      silent no-op
# This is separate from rule 4 below, which handles the component-assignment form.
Transform "data\minecraft\loot_table" {
  param($t)
  return ($t -replace '("function":\s*"minecraft:set_custom_model_data",\s*)"value":\s*(\d+)', '$1"floats": { "mode": "replace_all", "values": [$2] }')
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
