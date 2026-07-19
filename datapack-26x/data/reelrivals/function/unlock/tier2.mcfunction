tag @s add rr_u2
recipe give @s reelrivals:rod_master
recipe give @s reelrivals:bait_3
tellraw @s [{"text":"[Reel Rivals] ","color":"aqua"},{"text":"Master angler! Recipes unlocked: ","color":"green"},{"text":"Master's Rod","color":"yellow"},{"text":" + ","color":"green"},{"text":"Bait Tin III","color":"yellow"}]
playsound minecraft:entity.player.levelup master @s ~ ~ ~ 0.8
