# Runs as the exact player who just reeled in a fishing rod (fishing_rod_hooked reward).
# Opens a short "just reeled" window; the catch scan attributes fish only to reeling players,
# so a bystander standing over your hook can no longer steal the catch or its points.
advancement revoke @s only reelrivals:tech/hooked
scoreboard players set @s rr.reelt 8
