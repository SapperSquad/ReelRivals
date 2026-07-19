# Admin: force-reset a stuck tournament. Refunds entrants their buy-in.
tellraw @a [{"text":"[Reel Rivals] ","color":"aqua"},{"text":"Tournament state force-reset by an admin.","color":"red"}]
bossbar set reelrivals:timer visible false
scoreboard objectives setdisplay sidebar
function reelrivals:tournament/cancel_refund
