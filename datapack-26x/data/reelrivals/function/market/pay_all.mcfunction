# Macro. Args: n (emeralds), cnt (fish count). Pays and records lifetime earnings.
$give @s minecraft:emerald $(n)
$scoreboard players add @s rr.sold $(n)
$tellraw @s [{"text":"[Reel Rivals] ","color":"aqua"},{"text":"Sold ","color":"green"},{"text":"$(cnt) fish","color":"yellow"},{"text":" for ","color":"green"},{"text":"$(n) emeralds","color":"yellow"},{"text":" at the flat rate. ","color":"gray"},{"text":"Sell big catches by hand for more.","color":"dark_gray"}]
