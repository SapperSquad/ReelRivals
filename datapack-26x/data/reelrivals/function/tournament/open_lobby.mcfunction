# Runs as the host. Opens a 60-second join window.
scoreboard players set #state rr.t 1
scoreboard players set #ticks rr.t 1200
scoreboard players set #pot rr.t 0
tellraw @a [{"text":"==============================","color":"gold"}]
tellraw @a [{"text":"[Reel Rivals] ","color":"aqua"},{"selector":"@s","color":"yellow"},{"text":" is hosting a FISHING TOURNAMENT!","color":"gold","bold":true}]
execute if score #mode rr.t matches 1 run tellraw @a [{"text":"  Scoring: ","color":"gray"},{"text":"Total Weight","color":"yellow"}]
execute if score #mode rr.t matches 2 run tellraw @a [{"text":"  Scoring: ","color":"gray"},{"text":"Biggest Catch","color":"yellow"}]
execute if score #mode rr.t matches 3 run tellraw @a [{"text":"  Scoring: ","color":"gray"},{"text":"Most Catches","color":"yellow"}]
tellraw @a [{"text":"  Duration: ","color":"gray"},{"score":{"name":"#dur","objective":"rr.t"},"color":"yellow"},{"text":" seconds   Buy-in: ","color":"gray"},{"score":{"name":"#buyin","objective":"rr.t"},"color":"yellow"},{"text":" emeralds","color":"gray"}]
execute if score #split rr.t matches 1 run tellraw @a [{"text":"  Payout: ","color":"gray"},{"text":"winner takes the pot","color":"yellow"}]
execute if score #split rr.t matches 2 run tellraw @a [{"text":"  Payout: ","color":"gray"},{"text":"60/30/10 to the top three","color":"yellow"}]
execute if score #target rr.t matches 1 run tellraw @a [{"text":"  Target: ","color":"gray"},{"text":"Rivers & Lakes only","color":"aqua"}]
execute if score #target rr.t matches 2 run tellraw @a [{"text":"  Target: ","color":"gray"},{"text":"Open Ocean only","color":"aqua"}]
execute if score #target rr.t matches 3 run tellraw @a [{"text":"  Target: ","color":"gray"},{"text":"Trophy Hunt - rare & legendary only","color":"aqua"}]
execute if score #gear rr.t matches 1 run tellraw @a [{"text":"  Gear: ","color":"gray"},{"text":"Fair Play - no Luck of the Sea allowed","color":"aqua"}]
execute if score #gear rr.t matches 2 run tellraw @a [{"text":"  Gear: ","color":"gray"},{"text":"Pro League - Luck of the Sea IV+ required","color":"aqua"}]
tellraw @a [{"text":"  >> ","color":"gray"},{"text":"[CLICK TO JOIN]","color":"green","bold":true,"clickEvent":{"action":"run_command","value":"/trigger rr.join"},"hoverEvent":{"action":"show_text","contents":"Pay the buy-in and enter"}},{"text":"  (60 seconds)","color":"gray"}]
tellraw @a [{"text":"==============================","color":"gold"}]
playsound minecraft:block.note_block.pling master @a ~ ~ ~ 1 1.4
# host joins automatically (and pays like everyone else)
scoreboard players set @s rr.join 1
function reelrivals:tournament/join
scoreboard players reset @s rr.join
