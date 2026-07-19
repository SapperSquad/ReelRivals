scoreboard players set #frenzy rr.t 1
scoreboard players operation #frenzyend rr.t = #ticks rr.t
scoreboard players remove #frenzyend rr.t 900
title @a[tag=rr_entrant] title {"text":"FEEDING FRENZY!","color":"gold","bold":true}
title @a[tag=rr_entrant] subtitle {"text":"+25% catch weight for 45 seconds","color":"yellow"}
tellraw @a[tag=rr_entrant] [{"text":"[Reel Rivals] ","color":"aqua"},{"text":"The water is boiling — FEEDING FRENZY! +25% weight!","color":"gold","bold":true}]
playsound minecraft:entity.dolphin.play master @a[tag=rr_entrant] ~ ~ ~ 1 0.8
