scoreboard players set #state rr.t 3
bossbar set reelrivals:timer visible false
scoreboard objectives setdisplay sidebar
execute store result score #day rr.t run time query day
tellraw @a [{"text":"==============================","color":"gold"}]
tellraw @a [{"text":"[Reel Rivals] ","color":"aqua"},{"text":"TIME! The tournament is over!","color":"gold","bold":true}]
playsound minecraft:ui.toast.challenge_complete master @a ~ ~ ~ 1

# rank the top three
tag @a remove rr_ranked
function reelrivals:tournament/rank_pass {n:"1"}
function reelrivals:tournament/rank_pass {n:"2"}
function reelrivals:tournament/rank_pass {n:"3"}

# standings
execute if entity @a[tag=rr_rank1] run tellraw @a [{"text":"  1st  ","color":"gold","bold":true},{"selector":"@a[tag=rr_rank1,limit=1]","color":"yellow"},{"text":"  —  ","color":"gray"},{"score":{"name":"@a[tag=rr_rank1,limit=1]","objective":"rr.score"},"color":"gold"},{"text":" pts","color":"gray"}]
execute if entity @a[tag=rr_rank2] run tellraw @a [{"text":"  2nd  ","color":"white","bold":true},{"selector":"@a[tag=rr_rank2,limit=1]","color":"yellow"},{"text":"  —  ","color":"gray"},{"score":{"name":"@a[tag=rr_rank2,limit=1]","objective":"rr.score"},"color":"white"},{"text":" pts","color":"gray"}]
execute if entity @a[tag=rr_rank3] run tellraw @a [{"text":"  3rd  ","color":"#CD7F32","bold":true},{"selector":"@a[tag=rr_rank3,limit=1]","color":"yellow"},{"text":"  —  ","color":"gray"},{"score":{"name":"@a[tag=rr_rank3,limit=1]","objective":"rr.score"},"color":"#CD7F32"},{"text":" pts","color":"gray"}]
tellraw @a [{"text":"==============================","color":"gold"}]

function reelrivals:tournament/payout
function reelrivals:tournament/trophies
execute as @a[tag=rr_rank1] run scoreboard players add @s rr.wins 1
execute as @a[tag=rr_rank1] run advancement grant @s only reelrivals:champion
function reelrivals:tournament/cleanup
