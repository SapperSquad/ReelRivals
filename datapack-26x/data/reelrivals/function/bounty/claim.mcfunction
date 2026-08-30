# Runs as the catching player, once per bounty rotation (guarded by rr_bounty_claimed).
tag @s add rr_bounty_claimed
give @s minecraft:emerald 16
scoreboard players add @s rr.bounties 1
tellraw @s [{"text":"[Reel Rivals] ","color":"aqua"},{"text":"Bounty claimed! ","color":"gold","bold":true},{"text":"+16 emeralds","color":"green"},{"text":" for landing this rotation's target.","color":"gray"}]
tellraw @a[tag=!rr_bounty_claimed] [{"text":"[Reel Rivals] ","color":"aqua"},{"selector":"@s"},{"text":" just claimed the bounty — it's still open for you.","color":"gray"}]
