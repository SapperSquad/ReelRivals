# Hand the player an Angler's Almanac.
loot give @s loot reelrivals:guide_book
tellraw @s [{"text":"[Reel Rivals] ","color":"aqua"},{"text":"The Angler's Almanac has been added to your inventory.","color":"green"}]
playsound minecraft:item.book.page_turn master @s ~ ~ ~ 1
function reelrivals:verify_loot
