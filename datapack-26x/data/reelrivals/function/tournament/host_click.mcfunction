# Runs as a player who typed /trigger rr.host
scoreboard players reset @s rr.host
execute unless score #state rr.t matches 0 run tellraw @s [{"text":"[Reel Rivals] ","color":"aqua"},{"text":"A tournament is already forming or in progress.","color":"red"}]
execute unless score #state rr.t matches 0 run return 0
tag @a remove rr_host
tag @s add rr_host
scoreboard players set #mode rr.t 2
scoreboard players set #dur rr.t 600
scoreboard players set #buyin rr.t 4
scoreboard players set #split rr.t 1
scoreboard players set #target rr.t 0
scoreboard players set #gear rr.t 0
execute store result storage reelrivals:cfg n int 1 run scoreboard players get #buyin rr.t
tellraw @s [{"text":"[Reel Rivals] ","color":"aqua"},{"text":"You are now hosting. Configure your tournament:","color":"green"}]
function reelrivals:tournament/menu
