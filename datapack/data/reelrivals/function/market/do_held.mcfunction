# Runs as the seller; main hand is known to hold a weighed fish.
# Value = floor(kg) / #emper, min 1 per fish; the active bounty species pays double; times stack count.
scoreboard players set #emv rr.t 0
execute store result score #cnt rr.tmp run data get entity @s SelectedItem.count
scoreboard players set #w rr.tmp 0
execute store result score #w rr.tmp run data get entity @s SelectedItem.components."minecraft:custom_data".reelrivals.w
# w is in 0.1-kg units; a pre-1.4.0 fish has no w, leaving #w at 0 -> clamps to the 1-emerald floor.
execute if score #w rr.tmp matches 1.. run scoreboard players operation #emv rr.t = #w rr.tmp
scoreboard players operation #emv rr.t /= #10 rr.const
scoreboard players operation #emv rr.t /= #emper rr.t
execute if score #emv rr.t matches ..0 run scoreboard players set #emv rr.t 1

# bounty premium (per fish, before stack multiply)
data modify storage reelrivals:sell fs set value ""
data modify storage reelrivals:sell fs set from entity @s SelectedItem.components."minecraft:custom_data".reelrivals.species
function reelrivals:market/bounty_mult with storage reelrivals:sell

scoreboard players operation #emv rr.t *= #cnt rr.tmp

# remove the held stack, then pay
item replace entity @s weapon.mainhand with minecraft:air
execute store result storage reelrivals:sell n int 1 run scoreboard players get #emv rr.t
function reelrivals:market/pay with storage reelrivals:sell
