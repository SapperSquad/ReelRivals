# Macro. Runs as the record-setting player. Args: species, disp.
$scoreboard players operation #rec.$(species) rr.rec = #last rr.t
$scoreboard players operation #rec.$(species).kg rr.rec = #last rr.t
$scoreboard players operation #rec.$(species).kg rr.rec /= #10 rr.const
$scoreboard players operation #rec.$(species).fr rr.rec = #last rr.t
$scoreboard players operation #rec.$(species).fr rr.rec %= #10 rr.const
$execute store result score #rec.$(species).day rr.rec run time query day
# stamp the holder: the ledger reads the current name of whoever wears this species' record tag
$tag @a remove rr_rec_$(species)
$tag @s add rr_rec_$(species)
$tellraw @a [{"text":"[Reel Rivals] ","color":"aqua"},{"text":"NEW SERVER RECORD! ","color":"gold","bold":true},{"selector":"@s"},{"text":" landed a $(disp) weighing ","color":"yellow"},{"score":{"name":"#rec.$(species).kg","objective":"rr.rec"},"color":"gold"},{"text":".","color":"gold"},{"score":{"name":"#rec.$(species).fr","objective":"rr.rec"},"color":"gold"},{"text":" kg!","color":"yellow"}]
playsound minecraft:ui.toast.challenge_complete master @a ~ ~ ~ 0.6
