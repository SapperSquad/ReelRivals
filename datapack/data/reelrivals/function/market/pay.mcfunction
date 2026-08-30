# Macro. Arg: n (emeralds). Pays the seller and records lifetime earnings.
$give @s minecraft:emerald $(n)
$scoreboard players add @s rr.sold $(n)
$tellraw @s [{"text":"[Reel Rivals] ","color":"aqua"},{"text":"Sold for ","color":"green"},{"text":"$(n) emeralds","color":"yellow"},{"text":".","color":"gray"}]
