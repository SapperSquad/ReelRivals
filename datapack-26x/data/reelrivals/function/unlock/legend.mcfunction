tag @s add rr_u5
recipe give @s reelrivals:rod_legend
advancement grant @s only reelrivals:legend_rod
tellraw @a [{"text":"[Reel Rivals] ","color":"aqua"},{"selector":"@s","color":"yellow"},{"text":" has earned the ","color":"gold"},{"text":"Legend Rod","color":"dark_aqua","bold":true},{"text":" - every species on the ledger and a leviathan on the line!","color":"gold"}]
playsound minecraft:ui.toast.challenge_complete master @s ~ ~ ~ 1
