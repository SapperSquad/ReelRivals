scoreboard players operation #sec rr.t = #ticks rr.t
scoreboard players operation #sec rr.t /= #20 rr.const
execute store result bossbar reelrivals:timer value run scoreboard players get #sec rr.t
scoreboard players operation #min rr.t = #sec rr.t
scoreboard players operation #min rr.t /= #60 rr.const
scoreboard players operation #ss rr.t = #sec rr.t
scoreboard players operation #ss rr.t %= #60 rr.const
execute store result storage reelrivals:cfg m int 1 run scoreboard players get #min rr.t
execute store result storage reelrivals:cfg s int 1 run scoreboard players get #ss rr.t
execute if score #ss rr.t matches 10.. run function reelrivals:tournament/bossbar_name with storage reelrivals:cfg
execute if score #ss rr.t matches ..9 run function reelrivals:tournament/bossbar_name_pad with storage reelrivals:cfg
execute if score #sec rr.t matches 60 run tellraw @a[tag=rr_entrant] [{"text":"[Reel Rivals] ","color":"aqua"},{"text":"One minute remains!","color":"yellow","bold":true}]
execute if score #sec rr.t matches 10 run tellraw @a[tag=rr_entrant] [{"text":"[Reel Rivals] ","color":"aqua"},{"text":"10 seconds!","color":"red","bold":true}]
execute if score #sec rr.t matches 10 run playsound minecraft:block.note_block.hat master @a[tag=rr_entrant] ~ ~ ~ 1 1.8
