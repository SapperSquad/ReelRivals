scoreboard players remove #ticks rr.t 1
execute if score #ticks rr.t matches 200 run tellraw @a [{"text":"[Reel Rivals] ","color":"aqua"},{"text":"10 seconds to join! ","color":"yellow"},{"text":"[JOIN]","color":"green","bold":true,"clickEvent":{"action":"run_command","value":"/trigger rr.join"}}]
execute if score #ticks rr.t matches 1.. run return 0
# join window closed
execute store result score #tmp rr.t if entity @a[tag=rr_entrant]
execute if score #tmp rr.t matches ..1 run tellraw @a [{"text":"[Reel Rivals] ","color":"aqua"},{"text":"Not enough anglers (2 minimum). Tournament cancelled — buy-ins refunded.","color":"red"}]
execute if score #tmp rr.t matches ..1 run function reelrivals:tournament/cancel_refund
execute if score #tmp rr.t matches 2.. run function reelrivals:tournament/begin
