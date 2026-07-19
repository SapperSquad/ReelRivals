# Queues emerald payouts into rr.owed (auto-delivered by tick when the player is online).
execute if score #pot rr.t matches ..0 run return 0

# winner takes all
execute if score #split rr.t matches 1 as @a[tag=rr_rank1,limit=1] run scoreboard players operation @s rr.owed += #pot rr.t

# 60/30/10 — shares for missing placers roll up to 1st
execute if score #split rr.t matches 2 run scoreboard players operation #s3 rr.t = #pot rr.t
execute if score #split rr.t matches 2 run scoreboard players operation #s3 rr.t /= #10 rr.const
execute if score #split rr.t matches 2 run scoreboard players operation #s2 rr.t = #s3 rr.t
execute if score #split rr.t matches 2 run scoreboard players operation #s2 rr.t *= #2 rr.const
execute if score #split rr.t matches 2 run scoreboard players operation #s2 rr.t += #s3 rr.t
execute if score #split rr.t matches 2 run scoreboard players operation #s1 rr.t = #pot rr.t
execute if score #split rr.t matches 2 run scoreboard players operation #s1 rr.t -= #s2 rr.t
execute if score #split rr.t matches 2 run scoreboard players operation #s1 rr.t -= #s3 rr.t
execute if score #split rr.t matches 2 unless entity @a[tag=rr_rank3] run scoreboard players operation #s1 rr.t += #s3 rr.t
execute if score #split rr.t matches 2 unless entity @a[tag=rr_rank3] run scoreboard players set #s3 rr.t 0
execute if score #split rr.t matches 2 unless entity @a[tag=rr_rank2] run scoreboard players operation #s1 rr.t += #s2 rr.t
execute if score #split rr.t matches 2 unless entity @a[tag=rr_rank2] run scoreboard players set #s2 rr.t 0
execute if score #split rr.t matches 2 as @a[tag=rr_rank1,limit=1] run scoreboard players operation @s rr.owed += #s1 rr.t
execute if score #split rr.t matches 2 as @a[tag=rr_rank2,limit=1] run scoreboard players operation @s rr.owed += #s2 rr.t
execute if score #split rr.t matches 2 as @a[tag=rr_rank3,limit=1] run scoreboard players operation @s rr.owed += #s3 rr.t

tellraw @a [{"text":"[Reel Rivals] ","color":"aqua"},{"text":"Pot of ","color":"green"},{"score":{"name":"#pot","objective":"rr.t"},"color":"yellow"},{"text":" emeralds paid out to the podium!","color":"green"}]
