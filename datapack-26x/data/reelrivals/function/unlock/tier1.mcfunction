tag @s add rr_u1
recipe give @s reelrivals:rod_angler
recipe give @s reelrivals:bait_2
advancement grant @s only reelrivals:regular
tellraw @s [{"text":"[Reel Rivals] ","color":"aqua"},{"text":"10 catches! Recipes unlocked: ","color":"green"},{"text":"Angler's Rod","color":"yellow"},{"text":" + ","color":"green"},{"text":"Bait Tin II","color":"yellow"}]
playsound minecraft:entity.player.levelup master @s ~ ~ ~ 0.8
