# Macro. Runs as the catching entrant during a tournament. Arg: species.
# Sets #counts to 0 if this catch does not meet the tournament's target or gear rules.
# target: 1=Rivers&Lakes, 2=Ocean, 3=Trophy (0=any, no check)
$execute if score #target rr.t matches 1 unless data storage reelrivals:cat fresh.$(species) run scoreboard players set #counts rr.t 0
$execute if score #target rr.t matches 2 unless data storage reelrivals:cat salt.$(species) run scoreboard players set #counts rr.t 0
$execute if score #target rr.t matches 3 unless data storage reelrivals:cat trophy.$(species) run scoreboard players set #counts rr.t 0
# gear: 1=no Luck of the Sea allowed, 2=Luck of the Sea IV+ required (checks main hand rod)
execute if score #gear rr.t matches 1 if predicate reelrivals:gear_luck1 run scoreboard players set #counts rr.t 0
execute if score #gear rr.t matches 2 unless predicate reelrivals:gear_luck4 run scoreboard players set #counts rr.t 0
