tag @s add rr_u8
recipe give @s reelrivals:rod_naturalist
tellraw @a [{"text":"[Reel Rivals] ","color":"aqua"},{"selector":"@s","color":"yellow"},{"text":" has fished every water in the world and earned the ","color":"green"},{"text":"Naturalist's Rod","color":"green","bold":true},{"text":"!","color":"green"}]
playsound minecraft:ui.toast.challenge_complete master @s ~ ~ ~ 1
