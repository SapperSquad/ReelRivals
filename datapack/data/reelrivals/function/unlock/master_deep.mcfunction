tag @s add rr_u7
advancement grant @s only reelrivals:master_deep
give @s minecraft:tropical_fish[minecraft:item_name='{"text":"Master of the Deep","color":"dark_aqua","bold":true}',minecraft:lore=['{"text":"One thousand catches.","color":"gray","italic":false}','{"text":"The water knows this one by name.","color":"dark_gray","italic":true}'],minecraft:custom_data={reelrivals:{trophy:"master_deep"}},minecraft:enchantment_glint_override=true,minecraft:max_stack_size=1,minecraft:custom_model_data=790104] 1
tellraw @a [{"text":"==============================","color":"dark_aqua"}]
tellraw @a [{"text":"[Reel Rivals] ","color":"aqua"},{"selector":"@s","color":"yellow"},{"text":" has landed their ","color":"dark_aqua"},{"text":"1,000th catch","color":"dark_aqua","bold":true},{"text":" - MASTER OF THE DEEP!","color":"dark_aqua","bold":true}]
tellraw @a [{"text":"==============================","color":"dark_aqua"}]
playsound minecraft:ui.toast.challenge_complete master @a ~ ~ ~ 1
