tag @s add rr_u9
recipe give @s reelrivals:rod_grandmaster
advancement grant @s only reelrivals:grandmaster
tellraw @a [{"text":"[Reel Rivals] ","color":"aqua"},{"selector":"@s","color":"yellow"},{"text":" rules the circuit - the ","color":"light_purple"},{"text":"Grandmaster's Rod","color":"light_purple","bold":true},{"text":" is theirs!","color":"light_purple"}]
playsound minecraft:ui.toast.challenge_complete master @a ~ ~ ~ 1
