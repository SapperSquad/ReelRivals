# Runs as the seller; #n rr.tmp holds the count of weighed fish. Flat 2 emeralds each.
scoreboard players operation #emv rr.t = #n rr.tmp
scoreboard players operation #emv rr.t *= #2 rr.const
clear @s *[minecraft:custom_data~{reelrivals:{weighed:1b}}]
execute store result storage reelrivals:sell n int 1 run scoreboard players get #emv rr.t
execute store result storage reelrivals:sell cnt int 1 run scoreboard players get #n rr.tmp
function reelrivals:market/pay_all with storage reelrivals:sell
