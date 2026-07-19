# Macro. Runs as the item entity being converted. Args: species, disp, color, cmd.
$data modify entity @s Item.components."minecraft:custom_data".reelrivals merge value {species:"$(species)",common:0b}
$data modify entity @s Item.components."minecraft:item_name" set value '{"text":"$(disp)","color":"$(color)"}'
$data modify entity @s Item.components."minecraft:custom_model_data" set value {floats:[$(cmd)]}
