# Runs as an online player with queued winnings.
execute store result storage reelrivals:pay n int 1 run scoreboard players get @s rr.owed
function reelrivals:tournament/payone with storage reelrivals:pay
scoreboard players set @s rr.owed 0
