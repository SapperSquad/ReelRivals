# Macro. Runs as the catching player after a successful lure conversion. Args: species, disp (lure name).
scoreboard players set #conv rr.t 0
$clear @s minecraft:slime_ball[minecraft:custom_data~{reelrivals:{lure:"$(species)"}}] 1
$title @s actionbar [{"text":"Your $(disp) worked!","color":"green"}]
playsound minecraft:entity.experience_orb.pickup master @s ~ ~ ~ 0.7 1.6
