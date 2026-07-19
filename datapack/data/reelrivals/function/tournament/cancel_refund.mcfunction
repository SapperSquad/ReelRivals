# Refund all entrants their buy-in (queued via rr.owed, auto-delivered when online).
execute as @a[tag=rr_entrant] run scoreboard players operation @s rr.owed += #buyin rr.t
scoreboard players set #pot rr.t 0
function reelrivals:tournament/cleanup
