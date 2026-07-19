# Runs as the host after /trigger rr.gear set <1-3>
execute store result score #tmp rr.t run scoreboard players get @s rr.gear
execute if score #tmp rr.t matches 1 run scoreboard players set #gear rr.t 0
execute if score #tmp rr.t matches 2 run scoreboard players set #gear rr.t 1
execute if score #tmp rr.t matches 3 run scoreboard players set #gear rr.t 2
execute unless score #tmp rr.t matches 1..3 run scoreboard players set #gear rr.t 0
execute if score #gear rr.t matches 0 run tellraw @s [{"text":"[Reel Rivals] ","color":"aqua"},{"text":"Gear rule: Any rod allowed","color":"green"}]
execute if score #gear rr.t matches 1 run tellraw @s [{"text":"[Reel Rivals] ","color":"aqua"},{"text":"Gear rule: Fair Play - no Luck of the Sea allowed","color":"green"}]
execute if score #gear rr.t matches 2 run tellraw @s [{"text":"[Reel Rivals] ","color":"aqua"},{"text":"Gear rule: Pro League - Luck of the Sea IV or better required","color":"green"}]
