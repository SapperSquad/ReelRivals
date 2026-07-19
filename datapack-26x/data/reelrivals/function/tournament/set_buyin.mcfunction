# Runs as the host after /trigger rr.buyin set <1-8>
execute store result score #tmp rr.t run scoreboard players get @s rr.buyin
execute if score #tmp rr.t matches 1 run scoreboard players set #buyin rr.t 0
execute if score #tmp rr.t matches 2 run scoreboard players set #buyin rr.t 1
execute if score #tmp rr.t matches 3 run scoreboard players set #buyin rr.t 2
execute if score #tmp rr.t matches 4 run scoreboard players set #buyin rr.t 4
execute if score #tmp rr.t matches 5 run scoreboard players set #buyin rr.t 8
execute if score #tmp rr.t matches 6 run scoreboard players set #buyin rr.t 16
execute if score #tmp rr.t matches 7 run scoreboard players set #buyin rr.t 32
execute if score #tmp rr.t matches 8 run scoreboard players set #buyin rr.t 64
execute unless score #tmp rr.t matches 1..8 run scoreboard players set #buyin rr.t 4
execute store result storage reelrivals:cfg n int 1 run scoreboard players get #buyin rr.t
tellraw @s [{"text":"[Reel Rivals] ","color":"aqua"},{"text":"Buy-in set: ","color":"green"},{"score":{"name":"#buyin","objective":"rr.t"},"color":"yellow"},{"text":" emeralds","color":"green"}]
