# Runs as (and at) a freshly-caught, still-unweighed fish item entity (from the tick scan).
# Attribute to the player who actually reeled in (has an open rr.reelt window), NOT merely the
# nearest player - this stops catch/point theft by someone standing over your hook.
scoreboard players add @s rr.age 1
execute as @p[scores={rr.reelt=1..},distance=..48] run function reelrivals:catch/process
# Fallback: if no reeling player has claimed it within ~1.5s (advancement missed), weigh it via
# the nearest player so the fish still gets its weight. Rare; keeps the core feature robust.
execute if score @s rr.age matches 30.. as @p[distance=..32] run function reelrivals:catch/process
