# /trigger rr.stats — the Angler's Log: this player's own lifetime numbers. Runs as @s.
# personal best weight (0.1-kg units) split into kg . tenths for display
scoreboard players operation #pbkg rr.tmp = @s rr.pb
scoreboard players operation #pbkg rr.tmp /= #10 rr.const
scoreboard players operation #pbfr rr.tmp = @s rr.pb
scoreboard players operation #pbfr rr.tmp %= #10 rr.const

tellraw @s [{"text":"====== Angler's Log ======","color":"aqua","bold":true}]
tellraw @s [{"text":"  ","color":"gray"},{"selector":"@s","color":"white","bold":true}]
tellraw @s [{"text":"  Lifetime catches: ","color":"gray"},{"score":{"name":"@s","objective":"rr.caught"},"color":"yellow"}]
tellraw @s [{"text":"  Personal best: ","color":"gray"},{"score":{"name":"#pbkg","objective":"rr.tmp"},"color":"white"},{"text":".","color":"white"},{"score":{"name":"#pbfr","objective":"rr.tmp"},"color":"white"},{"text":" kg","color":"gray"}]
tellraw @s [{"text":"  Tournaments: ","color":"gray"},{"score":{"name":"@s","objective":"rr.played"},"color":"white"},{"text":" played, ","color":"gray"},{"score":{"name":"@s","objective":"rr.wins"},"color":"gold"},{"text":" won","color":"gray"}]
tellraw @s [{"text":"  Bounties claimed: ","color":"gray"},{"score":{"name":"@s","objective":"rr.bounties"},"color":"gold"}]
tellraw @s [{"text":"  Earned at market: ","color":"gray"},{"score":{"name":"@s","objective":"rr.sold"},"color":"green"},{"text":" emeralds","color":"gray"}]
tellraw @s [{"text":"  Gear earned:","color":"gray"}]
execute if entity @s[tag=rr_u2] run tellraw @s [{"text":"    - Master's Rod","color":"dark_purple"}]
execute if entity @s[tag=rr_u8] run tellraw @s [{"text":"    - Naturalist's Rod","color":"dark_green"}]
execute if entity @s[tag=rr_u5] run tellraw @s [{"text":"    - Legend Rod","color":"dark_aqua"}]
execute if entity @s[tag=rr_u3] run tellraw @s [{"text":"    - Champion's Rod","color":"gold"}]
execute if entity @s[tag=rr_u9] run tellraw @s [{"text":"    - Grandmaster's Rod","color":"light_purple"}]
execute unless entity @s[tag=rr_u2] unless entity @s[tag=rr_u3] run tellraw @s [{"text":"    (nothing yet - keep fishing!)","color":"dark_gray"}]
tellraw @s [{"text":"  This rotation's bounty: ","color":"gray"},{"nbt":"disp","storage":"reelrivals:bounty","color":"gold"}]
tellraw @s [{"text":"==========================","color":"aqua"}]
