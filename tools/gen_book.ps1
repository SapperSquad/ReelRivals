# Angler's Almanac generator v5 - auto page numbering (links resolve by section name),
# two contents pages, clearer lure wording (no ">"), 14-line page budget. ASCII only.
$enc = New-Object System.Text.UTF8Encoding($false)

function Seg($t,$c)  { '{"text":"' + $t + '","color":"' + $c + '"}' }
function SegB($t,$c) { '{"text":"' + $t + '","color":"' + $c + '","bold":true}' }
function SegI($t,$c) { '{"text":"' + $t + '","color":"' + $c + '","italic":true}' }
function Hdr($t)     { SegB ($t + '\n') "dark_blue" }
# a fish entry: bold name, then a plain info line
function Fish($name,$color,$info) { @( (SegB ($name + '\n') $color), (Seg (' ' + $info + '\n') "black") ) }
# a lure entry: bold name, then "catches <fish>" in plain English (no symbols)
function Lure($name,$color,$fish) { @( (SegB ($name + '\n') $color), (Seg (' catches ' + $fish + '\n') "black") ) }
# a gear entry: name + recipe (bait/rods keep their build path)
function Gear($name,$color,$recipe) { @( (SegB ($name + '\n') $color), (Seg (' ' + $recipe + '\n') "black") ) }

$P = @{}   # section-name -> page number (filled after ordering)
function Link($text,$key) { '{"text":"' + $text + '","color":"#1A44B8","underlined":true,"clickEvent":{"action":"change_page","value":"' + $P[$key] + '"}}' }
function Foot() { Link '<< Contents' 'contents1' }

# ---- ordered page list: key + builder scriptblock (built after numbering) ----
$order = @(
  "cover","contents1","contents2","basics",
  "rivers","lakes","ocean","warmice","deeps","swampjungle","newfish1","newfish2","abyssfish","schedules","legends",
  "lures101","lures_river","lures_lake","lures_ocean","lures_colddeep","lures_wilds","lures_rare","lures_new",
  "bait","rods","rods_nat","rods_cir","tournaments","grind"
)
for ($i=0; $i -lt $order.Count; $i++) { $P[$order[$i]] = ($i + 1) }

$build = @{
 cover = { @( (SegB '\n*  The Angler~s\n     Almanac  *\n\n' "dark_blue"), (Seg 'Every catch has a weight. Records are kept. Rivals are watching.\n\n' "black"), (SegI '28 fish, their lures, and the tournament circuit.' "dark_gray") ) }
 contents1 = { @(
   (SegB 'Contents - Fish\n' "dark_blue"), (SegI 'tap a blue link\n' "dark_gray"),
   (Link 'How It Works\n' 'basics'),
   (Link 'Rivers' 'rivers'), (Seg '  ' "gray"), (Link 'Lakes\n' 'lakes'),
   (Link 'Ocean' 'ocean'), (Seg '  ' "gray"), (Link 'Warm & Ice\n' 'warmice'),
   (Link 'The Deeps' 'deeps'), (Seg '  ' "gray"), (Link 'Swamp/Jungle\n' 'swampjungle'),
   (Link 'Rare Species' 'newfish1'), (Seg '  ' "gray"), (Link 'Legends\n' 'legends'),
   (Link 'Day & Night Guide\n' 'schedules'),
   (Seg '\n' "black"), (Link '>> Tackle & Rules' 'contents2')
 ) }
 contents2 = { @(
   (SegB 'Contents - Tackle\n' "dark_blue"),
   (Link 'How Lures Work\n' 'lures101'),
   (Link 'River Lures' 'lures_river'), (Seg ' ' "gray"), (Link 'Lake\n' 'lures_lake'),
   (Link 'Ocean Lures' 'lures_ocean'), (Seg ' ' "gray"), (Link 'Cold/Deep\n' 'lures_colddeep'),
   (Link 'Wild Lures' 'lures_wilds'), (Seg ' ' "gray"), (Link 'Rare Lures\n' 'lures_rare'),
   (Link 'Bait Tins' 'bait'), (Seg '  ' "gray"), (Link 'Rods\n' 'rods'),
   (Link 'Tournaments' 'tournaments'), (Seg ' ' "gray"), (Link 'The Grind\n' 'grind'),
   (Seg '\n' "black"), (Link '<< Fish' 'contents1')
 ) }
 basics = { @( (Hdr 'How It Works'),
   (Seg 'Every fish you reel in is weighed and the weight is inked on it.\n' "black"),
   (Seg 'Beat a species record and the server hears about it.\n' "black"),
   (Seg 'Luck draws rare bites. Each lure targets one fish.\n' "black"), (Foot) ) }
 rivers = { ( @((Hdr 'Rivers')) + (Fish 'Golden Bass' "#8A6D00" '0.8-6kg, Luck') + (Fish 'Copper Trout' "#8A4B2A" '0.6-3.5kg') + (Fish 'Whiskered Catfish' "dark_gray" '2-9kg, heavy') + (Fish 'Mudskip Gar' "#556B2F" '2-7kg, night') + @((Foot)) ) }
 lakes = { ( @((Hdr 'Lakes & Ponds')) + (Fish 'Lake Perch' "#8A6D00" '0.5-3 kg, a staple') + (Fish 'Mirror Carp' "dark_gray" '1.5-8.5 kg, big') + (Fish 'Moonlit Koi' "dark_purple" '0.8-5 kg, night only') + @((Foot)) ) }
 ocean = { ( @((Hdr 'Open Ocean')) + (Fish 'Silver Herring' "dark_gray" '0.3-2kg, common') + (Fish 'Sunfin Tuna' "#8A6D00" '3-13kg, day') + (Fish 'Storm Marlin' "dark_blue" '3-12kg, rain') + (Fish 'Thunderfin' "#8A6D00" '4-14kg, storms') + @((Foot)) ) }
 warmice = { ( @((Hdr 'Warm & Frozen Seas')) + (Fish 'Ember Snapper' "dark_red" '0.6-4.5kg, warm') + (Fish 'Coral Empress' "#B03060" '2-8kg, warm day') + (Fish 'Frostfin Char' "#1F6E8C" '1-5.5kg, frozen') + (Fish 'Glacier Pike' "#1F6E8C" '3-10kg, frzn night') + @((Foot)) ) }
 deeps = { ( @((Hdr 'The Deeps')) + (Fish 'Deep Grouper' "dark_blue" '2.5-11 kg, deep ocean') + (Fish 'Abyssal Angler' "dark_purple" '1.5-6 kg, deep, night') + @((Foot)) ) }
 swampjungle = { ( @((Hdr 'Swamp & Jungle')) + (Fish 'Swamp Lurker' "dark_green" '1.5-8 kg, swamps') + (Fish 'Jungle Piranha' "dark_green" '0.5-3.5 kg, jungle') + (Fish 'Emperor Arowana' "#8A6D00" '3-9 kg, jungle, rare') + @((Foot)) ) }
 newfish1 = { @( (Hdr 'Rare Species'),
   (Seg 'The hard-to-find fish - luck and timing help.\n' "black"),
   (Fish 'Coral Empress' "#B03060" 'warm reefs at noon')[0], (Fish '' "#B03060" 'warm reefs at noon')[1],
   (Fish 'Emperor Arowana' "#8A6D00" 'jungle pools')[0], (Fish '' "#8A6D00" 'jungle pools')[1],
   (Fish 'Void Skate' "dark_purple" 'End waters - bring water!')[0], (Fish '' "dark_purple" 'End waters - bring water!')[1],
   (Foot) ) }
 newfish2 = { ( @((Hdr 'Rare Species II')) + (Fish 'Thunderfin' "#8A6D00" 'oceans in thunderstorms') + (Fish 'Abyssal Angler' "dark_purple" 'deep ocean at night') + (Fish 'Glacier Pike' "#1F6E8C" 'frozen water at night') + @((Foot)) ) }
 abyssfish = { ( @((Hdr 'Legends of the Deep')) + (Fish 'Ancient Coelacanth' "#5C3317" '10-20 kg, deep ocean') + @( (Seg 'Older than the sea. Near-mythical.\n' "black"), (Foot) ) ) }
 schedules = { @( (Hdr 'Day & Night Guide'),
   (SegB 'Night: ' "dark_purple"), (Seg 'Eel, Koi, Angler, Gar, Pike\n' "black"),
   (SegB 'Daytime: ' "#8A6D00"), (Seg 'Tuna, Coral Empress\n' "black"),
   (SegB 'Rain: ' "dark_blue"), (Seg 'Storm Marlin\n' "black"),
   (SegB 'Thunder: ' "#8A6D00"), (Seg 'Thunderfin\n' "black"),
   (SegI 'The right lure ignores these.\n' "dark_gray"), (Foot) ) }
 legends = { ( @((Hdr 'The King Sturgeon')) + (Fish 'King Sturgeon' "#8A6D00" '8-25 kg, anywhere') + @( (Seg 'Almost never bites. Stack Luck, or use the King~s Roe lure.\n' "black"), (Foot) ) ) }
 lures101 = { @( (Hdr 'How Lures Work'),
   (Seg 'Catch a fish once to learn its lure recipe.\n' "black"),
   (Seg 'Hold the lure in your OFF hand while fishing. About 1 in 3 bites turn into your target.\n' "black"),
   (SegI 'Recipes show in your crafting book once learned.\n' "dark_gray"), (Foot) ) }
 lures_river = { ( @((Hdr 'River Lures')) + (Lure 'Gilded Spinner' "#8A6D00" 'Golden Bass') + (Lure 'Copper Spinner' "#8A4B2A" 'Copper Trout') + (Lure 'Stink Bait' "dark_gray" 'Whiskered Catfish') + (Lure 'Mud Dauber' "#556B2F" 'Mudskip Gar') + @((Foot)) ) }
 lures_lake = { ( @((Hdr 'Lake Lures')) + (Lure 'Perch Popper' "#8A6D00" 'Lake Perch') + (Lure 'Silver Spinner' "dark_gray" 'Mirror Carp') + (Lure 'Moon Popper' "dark_purple" 'Moonlit Koi') + @((Foot)) ) }
 lures_ocean = { ( @((Hdr 'Ocean Lures')) + (Lure 'Herring Rig' "dark_gray" 'Silver Herring') + (Lure 'Sunfin Spoon' "#8A6D00" 'Sunfin Tuna') + (Lure 'Storm Jig' "dark_blue" 'Storm Marlin') + (Lure 'Thunder Jig' "#8A6D00" 'Thunderfin') + @((Foot)) ) }
 lures_colddeep = { ( @((Hdr 'Cold & Deep Lures')) + (Lure 'Ember Jig' "dark_red" 'Ember Snapper') + (Lure 'Frost Jig' "#1F6E8C" 'Frostfin Char') + (Lure 'Glacier Hook' "#1F6E8C" 'Glacier Pike') + (Lure 'Deep Jig' "dark_blue" 'Deep Grouper') + @((Foot)) ) }
 lures_wilds = { ( @((Hdr 'Wild Lures')) + (Lure 'Bog Creeper' "dark_green" 'Swamp Lurker') + (Lure 'Cocoa Popper' "dark_green" 'Jungle Piranha') + (Lure 'Royal Popper' "#8A6D00" 'Emperor Arowana') + (Lure 'Nightcrawler' "dark_purple" 'Midnight Eel') + @((Foot)) ) }
 lures_rare = { ( @((Hdr 'Rare & Legend Lures')) + (Lure 'Coral Charm' "#B03060" 'Coral Empress') + (Lure 'Abyssal Beacon' "dark_purple" 'Abyssal Angler') + (Lure 'Void Line' "dark_purple" 'Void Skate') + (Lure 'Fossil Bait' "#5C3317" 'Ancient Coelacanth') + @((Foot)) ) }
 lures_new = { ( @((Hdr 'The King~s Lure')) + (Lure 'King~s Roe' "#8A6D00" 'King Sturgeon') + @( (SegI 'Craft from a heart of the sea + golden apple. Tempts the King anywhere, 1 in 10.\n' "dark_gray"), (Foot) ) ) }
 bait = { ( @((Hdr 'Bait Tins'), (SegI 'Eat to boost Luck.\n' "dark_gray")) + (Gear 'Tin I, II, III' "black" 'early recipes') + (Gear 'Tin IV, Luck 4' "dark_aqua" '100 catches') + (Gear 'King~s Feast, Luck 5' "#8A6D00" '500 catches') + @((Foot)) ) }
 rods = { ( @((Hdr 'Rods')) + (Gear 'Angler~s Rod' "#1F6E8C" '10 catches') + (Gear 'Master~s Rod' "dark_purple" '50 catches or a 10 kg fish') + @(
   (Seg 'Then the path splits:\n' "black"),
   (Link 'Naturalist Path\n' 'rods_nat'),
   (Link 'Circuit Path\n' 'rods_cir'),
   (Foot) ) ) }
 rods_nat = { ( @((Hdr 'Naturalist Path'), (SegI 'Earned by exploring.\n' "dark_gray")) + (Gear 'Naturalist~s Rod' "dark_green" 'a catch in all 9 waters') + (Gear 'Legend Rod' "dark_aqua" 'every species + a 15 kg fish') + @((Foot)) ) }
 rods_cir = { ( @((Hdr 'Circuit Path'), (SegI 'Earned by winning.\n' "dark_gray")) + (Gear 'Champion~s Rod' "#8A6D00" '5 tournaments or 1 win') + (Gear 'Grandmaster~s Rod' "dark_purple" '5 wins, or 3 wins and 20 played') + @((Foot)) ) }
 tournaments = { @( (Hdr 'Tournaments'),
   (SegB 'rr.host' "dark_red"), (Seg ' host a match\n' "black"),
   (SegB 'rr.join' "dark_red"), (Seg ' enter & fish\n' "black"),
   (SegB 'rr.top' "dark_red"), (Seg ' leaderboard\n' "black"),
   (SegB 'rr.records' "dark_red"), (Seg ' the ledger\n' "black"),
   (SegI 'Type /trigger then the name. Hosts set scoring, target, buy-in, gear & payout.\n' "dark_gray"), (Foot) ) }
 grind = { @( (Hdr 'The Long Grind'),
   (Seg '100: Bait Tin IV\n' "black"),
   (Seg '15kg fish: Leviathan\n' "black"),
   (Seg 'All 28 + Lev: Legend Rod\n' "black"),
   (Seg '500: King~s Feast\n' "black"),
   (Seg '1000: Master of Deep\n' "black"),
   (SegI 'Luck V baits legends.\n' "dark_gray"), (Foot) ) }
}

function Est($segs) {
  $txt = ""
  foreach ($s in $segs) { if ($s -match '"text":"((?:[^"\\]|\\.)*)"') { $txt += $Matches[1] } }
  $txt = $txt.Replace('\n', "`n"); $ln = 0
  foreach ($chunk in ($txt -split "`n")) { if ($chunk -eq "") { $ln += 1 } else { $ln += [Math]::Ceiling($chunk.Length / 19.0) } }
  return $ln
}

$pages = @(); $over = 0; $n = 0
foreach ($key in $order) {
  $n++
  $segs = & $build[$key]
  $est = Est $segs
  if ($est -gt 14) { $over++; "PAGE $n ($key): ~$est lines  <-- OVER" }
  $pages += ,$segs
}
if ($over -eq 0) { "all $($pages.Count) pages within budget" }

$pageJson = @()
foreach ($p in $pages) { $pageJson += ('                [ {"text":""}, ' + (($p) -join ", ") + ' ]') }
$out = @'
{
  "pools": [
    { "rolls": 1, "entries": [ {
      "type": "minecraft:item",
      "name": "minecraft:written_book",
      "functions": [
        { "function": "minecraft:set_book_cover", "title": "Angler's Almanac", "author": "Reel Rivals" },
        { "function": "minecraft:set_custom_data", "tag": "{reelrivals:{guide:1b}}" },
        { "function": "minecraft:set_components", "components": { "minecraft:enchantment_glint_override": false } },
        { "function": "minecraft:set_written_book_pages", "mode": "append", "pages": [
PAGES
        ] }
      ]
    } ] }
  ]
}
'@
$out = $out.Replace("PAGES", ($pageJson -join ",`n")).Replace("~","'")
$path = "C:\Users\alexh\Documents\ReelRivals\datapack\data\reelrivals\loot_table\guide_book.json"
[System.IO.File]::WriteAllText($path, $out, $enc)
try { Get-Content $path -Raw -Encoding UTF8 | ConvertFrom-Json | Out-Null; "JSON valid, pages: $($pages.Count)" } catch { "JSON INVALID: " + $_.Exception.Message }
