# Runs as the host after /trigger rr.dur set <1-3>
execute store result score #tmp rr.t run scoreboard players get @s rr.dur
execute if score #tmp rr.t matches 1 run scoreboard players set #dur rr.t 300
execute if score #tmp rr.t matches 2 run scoreboard players set #dur rr.t 600
execute if score #tmp rr.t matches 3 run scoreboard players set #dur rr.t 900
execute unless score #tmp rr.t matches 1..3 run scoreboard players set #dur rr.t 600
tellraw @s [{"text":"[Reel Rivals] ","color":"aqua"},{"text":"Duration set: ","color":"green"},{"score":{"name":"#dur","objective":"rr.t"},"color":"yellow"},{"text":" seconds","color":"green"}]
