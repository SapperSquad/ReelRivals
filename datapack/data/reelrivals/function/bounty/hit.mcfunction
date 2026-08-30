# Macro. Runs as the catching player when the caught species is the active bounty. Arg: disp.
$title @s actionbar [{"text":"★ BOUNTY FISH ★  ","color":"gold","bold":true},{"text":"$(disp)","color":"yellow"}]
execute at @s run playsound minecraft:entity.player.levelup player @s ~ ~ ~ 0.6 1.6
# once-per-rotation lump reward
execute unless entity @s[tag=rr_bounty_claimed] run function reelrivals:bounty/claim
