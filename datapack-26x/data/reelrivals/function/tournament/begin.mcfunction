scoreboard players set #state rr.t 2
scoreboard players operation #ticks rr.t = #dur rr.t
scoreboard players operation #ticks rr.t *= #20 rr.const
scoreboard players operation #halftick rr.t = #ticks rr.t
scoreboard players operation #halftick rr.t /= #2 rr.const
scoreboard players set #frenzy rr.t 0
scoreboard players set @a[tag=rr_entrant] rr.score 0
scoreboard players add @a[tag=rr_entrant] rr.played 1
execute store result bossbar reelrivals:timer max run scoreboard players get #dur rr.t
execute store result bossbar reelrivals:timer value run scoreboard players get #dur rr.t
bossbar set reelrivals:timer players @a[tag=rr_entrant]
bossbar set reelrivals:timer visible true
scoreboard objectives setdisplay sidebar rr.score
scoreboard players set #topshown rr.t 0
title @a[tag=rr_entrant] title {"text":"GO FISH!","color":"aqua","bold":true}
title @a[tag=rr_entrant] subtitle {"text":"May the biggest catch win","color":"yellow"}
playsound minecraft:entity.player.levelup master @a ~ ~ ~ 1 1.2
tellraw @a [{"text":"[Reel Rivals] ","color":"aqua"},{"text":"The tournament has begun! Lines in the water!","color":"gold","bold":true}]
