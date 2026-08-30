# Decide whether the bounty target is due for a reroll. Called throttled from tick + once from load.
# Due if: no bounty is active yet, OR (current in-game day - start day) >= the period.
execute store result score #day rr.tmp run time query day
scoreboard players set #due rr.t 0
execute unless data storage reelrivals:bounty {active:1b} run scoreboard players set #due rr.t 1
scoreboard players operation #elapsed rr.t = #day rr.tmp
scoreboard players operation #elapsed rr.t -= #bstart rr.t
execute if score #elapsed rr.t >= #bperiod rr.t run scoreboard players set #due rr.t 1
execute if score #due rr.t matches 1 run function reelrivals:bounty/roll
