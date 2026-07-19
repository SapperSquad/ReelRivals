tag @s add rr_u6
recipe give @s reelrivals:bait_5
advancement grant @s only reelrivals:old_salt
tellraw @s [{"text":"[Reel Rivals] ","color":"aqua"},{"text":"500 catches! Recipe unlocked: ","color":"green"},{"text":"King's Feast (Tin V)","color":"gold"},{"text":" - the legends can smell it already.","color":"green"}]
playsound minecraft:ui.toast.challenge_complete master @s ~ ~ ~ 0.9
