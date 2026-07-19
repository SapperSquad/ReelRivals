# Runs as a player who typed /trigger rr.join
scoreboard players reset @s rr.join
execute unless score #state rr.t matches 1 run tellraw @s [{"text":"[Reel Rivals] ","color":"aqua"},{"text":"No tournament lobby is open right now.","color":"red"}]
execute unless score #state rr.t matches 1 run return 0
execute if entity @s[tag=rr_entrant] run tellraw @s [{"text":"[Reel Rivals] ","color":"aqua"},{"text":"You are already entered.","color":"yellow"}]
execute if entity @s[tag=rr_entrant] run return 0

# count emeralds without removing any (clear with maxCount 0 only queries)
execute store result score @s rr.tmp run clear @s minecraft:emerald 0
execute if score @s rr.tmp < #buyin rr.t run tellraw @s [{"text":"[Reel Rivals] ","color":"aqua"},{"text":"You need ","color":"red"},{"score":{"name":"#buyin","objective":"rr.t"},"color":"yellow"},{"text":" emeralds to enter.","color":"red"}]
execute if score @s rr.tmp < #buyin rr.t run return 0

# pay the buy-in into the pot
function reelrivals:tournament/pay_entry with storage reelrivals:cfg
scoreboard players operation #pot rr.t += #buyin rr.t
tag @s add rr_entrant
execute store result score #tmp rr.t if entity @a[tag=rr_entrant]
tellraw @a [{"text":"[Reel Rivals] ","color":"aqua"},{"selector":"@s","color":"yellow"},{"text":" entered the tournament! (","color":"green"},{"score":{"name":"#tmp","objective":"rr.t"},"color":"yellow"},{"text":" anglers, pot: ","color":"green"},{"score":{"name":"#pot","objective":"rr.t"},"color":"yellow"},{"text":" emeralds)","color":"green"}]
