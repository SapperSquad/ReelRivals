# Award fully-baked trophies to the podium (winner names are immortalized in chat + records).
execute store result storage reelrivals:t day int 1 run scoreboard players get #day rr.t

data modify storage reelrivals:t n set value "1"
data modify storage reelrivals:t title set value "Gold Trophy"
data modify storage reelrivals:t color set value "gold"
data modify storage reelrivals:t tier set value "gold"
execute if entity @a[tag=rr_rank1] store result storage reelrivals:t score int 1 run scoreboard players get @a[tag=rr_rank1,limit=1] rr.score
execute if entity @a[tag=rr_rank1] run function reelrivals:tournament/trophy_give with storage reelrivals:t

data modify storage reelrivals:t n set value "2"
data modify storage reelrivals:t title set value "Silver Trophy"
data modify storage reelrivals:t color set value "white"
data modify storage reelrivals:t tier set value "silver"
execute if entity @a[tag=rr_rank2] store result storage reelrivals:t score int 1 run scoreboard players get @a[tag=rr_rank2,limit=1] rr.score
execute if entity @a[tag=rr_rank2] run function reelrivals:tournament/trophy_give with storage reelrivals:t

data modify storage reelrivals:t n set value "3"
data modify storage reelrivals:t title set value "Bronze Trophy"
data modify storage reelrivals:t color set value "#CD7F32"
data modify storage reelrivals:t tier set value "bronze"
execute if entity @a[tag=rr_rank3] store result storage reelrivals:t score int 1 run scoreboard players get @a[tag=rr_rank3,limit=1] rr.score
execute if entity @a[tag=rr_rank3] run function reelrivals:tournament/trophy_give with storage reelrivals:t
