# Runs as the host after /trigger rr.split set <1-2>
execute store result score #split rr.t run scoreboard players get @s rr.split
execute unless score #split rr.t matches 1..2 run scoreboard players set #split rr.t 1
execute if score #split rr.t matches 1 run tellraw @s [{"text":"[Reel Rivals] ","color":"aqua"},{"text":"Payout: winner takes all","color":"green"}]
execute if score #split rr.t matches 2 run tellraw @s [{"text":"[Reel Rivals] ","color":"aqua"},{"text":"Payout: 60/30/10 split","color":"green"}]
