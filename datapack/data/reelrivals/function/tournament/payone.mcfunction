# Macro. Arg n = emeralds owed.
$give @s minecraft:emerald $(n)
$tellraw @s [{"text":"[Reel Rivals] ","color":"aqua"},{"text":"Winnings delivered: ","color":"green"},{"text":"$(n) emeralds","color":"yellow"}]
