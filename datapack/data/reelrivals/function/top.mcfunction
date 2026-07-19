# Toggle the Top Anglers sidebar (lifetime weighed catches, live-sorted, offline players included).
execute if score #state rr.t matches 2 run tellraw @s [{"text":"[Reel Rivals] ","color":"aqua"},{"text":"The sidebar is busy with a live tournament - try again after it ends.","color":"red"}]
execute if score #state rr.t matches 2 run return 0
execute store result score #tmp rr.t run scoreboard players get #topshown rr.t
execute if score #tmp rr.t matches 1 run scoreboard objectives setdisplay sidebar
execute if score #tmp rr.t matches 1 run scoreboard players set #topshown rr.t 0
execute if score #tmp rr.t matches 1 run tellraw @a [{"text":"[Reel Rivals] ","color":"aqua"},{"selector":"@s","color":"yellow"},{"text":" took the Top Anglers board down.","color":"gray"}]
execute if score #tmp rr.t matches 0 run scoreboard objectives setdisplay sidebar rr.caught
execute if score #tmp rr.t matches 0 run scoreboard players set #topshown rr.t 1
execute if score #tmp rr.t matches 0 run tellraw @a [{"text":"[Reel Rivals] ","color":"aqua"},{"selector":"@s","color":"yellow"},{"text":" posted the ","color":"green"},{"text":"Top Anglers","color":"aqua","bold":true},{"text":" board. (","color":"green"},{"text":"/trigger rr.top","color":"yellow"},{"text":" to dismiss)","color":"green"}]
