# Macro. Runs as the caught-fish item entity. Args: kg, fr.
execute unless data entity @s Item.components."minecraft:lore" run data modify entity @s Item.components."minecraft:lore" set value []
$data modify entity @s Item.components."minecraft:lore" append value '{"text":"Weight: $(kg).$(fr) kg","color":"gray","italic":false}'
data modify entity @s Item.components."minecraft:custom_data".reelrivals merge value {weighed:1b,unweighed:0b,common:0b}
