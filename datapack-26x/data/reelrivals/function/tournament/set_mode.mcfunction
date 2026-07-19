# Runs as the host after /trigger rr.mode set <1-3>
execute store result score #mode rr.t run scoreboard players get @s rr.mode
execute unless score #mode rr.t matches 1..3 run scoreboard players set #mode rr.t 2
execute if score #mode rr.t matches 1 run tellraw @s [{"text":"[Reel Rivals] ","color":"aqua"},{"text":"Scoring: Total Weight","color":"green"}]
execute if score #mode rr.t matches 2 run tellraw @s [{"text":"[Reel Rivals] ","color":"aqua"},{"text":"Scoring: Biggest Catch","color":"green"}]
execute if score #mode rr.t matches 3 run tellraw @s [{"text":"[Reel Rivals] ","color":"aqua"},{"text":"Scoring: Most Catches","color":"green"}]
