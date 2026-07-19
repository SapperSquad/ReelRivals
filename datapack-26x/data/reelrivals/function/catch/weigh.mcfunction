# Macro. Runs as a caught-fish item entity. Args: species, min, max (weight in 0.1 kg units).
$execute store result score @s rr.w run random value $(min)..$(max)

# feeding frenzy bonus: +25% weight
execute if score #frenzy rr.t matches 1 run scoreboard players operation @s rr.w *= #5 rr.const
execute if score #frenzy rr.t matches 1 run scoreboard players operation @s rr.w /= #4 rr.const

# split into display kg / tenths
scoreboard players operation @s rr.kg = @s rr.w
scoreboard players operation @s rr.kg /= #10 rr.const
scoreboard players operation @s rr.fr = @s rr.w
scoreboard players operation @s rr.fr %= #10 rr.const

# bake the weight into the item as literal lore text and flip the state flags
execute store result storage reelrivals:tmp kg int 1 run scoreboard players get @s rr.kg
execute store result storage reelrivals:tmp fr int 1 run scoreboard players get @s rr.fr
function reelrivals:catch/apply_weight with storage reelrivals:tmp

scoreboard players operation #last rr.t = @s rr.w
