tag @s add rr_u3
recipe give @s reelrivals:rod_champion
execute if score @s rr.played matches 5.. run advancement grant @s only reelrivals:veteran
tellraw @s [{"text":"[Reel Rivals] ","color":"aqua"},{"text":"Tournament veteran! Recipe unlocked: ","color":"green"},{"text":"Champion's Rod","color":"gold"}]
playsound minecraft:ui.toast.challenge_complete master @s ~ ~ ~ 0.8
