# Runs as the host after /trigger rr.start set <1|9>
execute store result score #tmp rr.t run scoreboard players get @s rr.start
execute if score #tmp rr.t matches 9 run tag @s remove rr_host
execute if score #tmp rr.t matches 9 run tellraw @s [{"text":"[Reel Rivals] ","color":"aqua"},{"text":"Tournament setup cancelled.","color":"red"}]
execute if score #tmp rr.t matches 9 run return 0
execute if score #tmp rr.t matches 1 unless score #state rr.t matches 0 run return 0
execute if score #tmp rr.t matches 1 run function reelrivals:tournament/open_lobby
