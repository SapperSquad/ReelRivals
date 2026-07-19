# Self-check: is our fishing loot override actually winning the pack order?
# Rolls the fishing fish table high above the player; every Reel Rivals entry carries
# reelrivals custom data, so a bare item means vanilla's table is overriding ours.
execute at @s positioned ~ 320 ~ run loot spawn ~ ~ ~ loot minecraft:gameplay/fishing/fish
execute at @s positioned ~ 320 ~ unless entity @e[type=item,distance=..4,nbt={Item:{components:{"minecraft:custom_data":{reelrivals:{}}}}}] run tellraw @s [{"text":"[Reel Rivals] ","color":"aqua"},{"text":"WARNING: another pack (or vanilla) is overriding the fishing loot - fish will not be weighed! Fix it by re-enabling this pack so it loads LAST: run ","color":"red"},{"text":"/datapack list","color":"yellow"},{"text":" to see its exact name, then ","color":"red"},{"text":"/datapack enable \"<name>\" last","color":"yellow"}]
execute at @s positioned ~ 320 ~ run kill @e[type=item,distance=..4]
