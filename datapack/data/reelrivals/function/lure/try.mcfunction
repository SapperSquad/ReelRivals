# Macro. Runs as a common (convertible) caught-fish item entity.
# Args: species, chance (1-100), disp (fish name), color, cmd (custom_model_data).
execute store result score @s rr.tmp run random value 1..100
$execute if score @s rr.tmp matches ..$(chance) run function reelrivals:lure/apply {species:"$(species)",disp:"$(disp)",color:"$(color)",cmd:"$(cmd)"}
$execute if score @s rr.tmp matches ..$(chance) run scoreboard players set #conv rr.t 1
