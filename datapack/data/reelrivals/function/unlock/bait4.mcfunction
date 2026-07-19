tag @s add rr_u4
recipe give @s reelrivals:bait_4
advancement grant @s only reelrivals:seasoned_angler
tellraw @s [{"text":"[Reel Rivals] ","color":"aqua"},{"text":"100 catches! Recipe unlocked: ","color":"green"},{"text":"Abyssal Chum (Tin IV)","color":"dark_aqua"}]
playsound minecraft:entity.player.levelup master @s ~ ~ ~ 0.8
