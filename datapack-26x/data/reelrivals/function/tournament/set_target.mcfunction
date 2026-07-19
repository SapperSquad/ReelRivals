# Runs as the host after /trigger rr.target set <1-4>
execute store result score #tmp rr.t run scoreboard players get @s rr.target
execute if score #tmp rr.t matches 1 run scoreboard players set #target rr.t 0
execute if score #tmp rr.t matches 2 run scoreboard players set #target rr.t 1
execute if score #tmp rr.t matches 3 run scoreboard players set #target rr.t 2
execute if score #tmp rr.t matches 4 run scoreboard players set #target rr.t 3
execute unless score #tmp rr.t matches 1..4 run scoreboard players set #target rr.t 0
execute if score #target rr.t matches 0 run tellraw @s [{"text":"[Reel Rivals] ","color":"aqua"},{"text":"Target: Any Fish","color":"green"}]
execute if score #target rr.t matches 1 run tellraw @s [{"text":"[Reel Rivals] ","color":"aqua"},{"text":"Target: Rivers & Lakes only","color":"green"}]
execute if score #target rr.t matches 2 run tellraw @s [{"text":"[Reel Rivals] ","color":"aqua"},{"text":"Target: Open Ocean only","color":"green"}]
execute if score #target rr.t matches 3 run tellraw @s [{"text":"[Reel Rivals] ","color":"aqua"},{"text":"Target: Trophy Hunt (rare & legendary only)","color":"green"}]
