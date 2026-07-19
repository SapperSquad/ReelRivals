# decay each player's "just reeled" window (set by the fishing_rod_hooked advancement)
scoreboard players remove @a[scores={rr.reelt=1..}] rr.reelt 1

# catch detection: each unweighed fish item is attributed to the reeling player by catch/scan
execute as @e[type=item,nbt={Item:{components:{"minecraft:custom_data":{reelrivals:{unweighed:1b}}}}}] at @s run function reelrivals:catch/scan

# trigger handlers first (read values, then reset the used score)
execute as @a[scores={rr.help=1..}] run function reelrivals:help
scoreboard players reset @a rr.help
execute as @a[scores={rr.records=1..}] run function reelrivals:records
scoreboard players reset @a rr.records
execute as @a[scores={rr.guide=1..}] run function reelrivals:guide
scoreboard players reset @a rr.guide
execute as @a[scores={rr.top=1..}] run function reelrivals:top
scoreboard players reset @a rr.top
execute as @a[scores={rr.host=1..}] run function reelrivals:tournament/host_click
scoreboard players reset @a rr.host
execute as @a[tag=rr_host,scores={rr.mode=1..}] run function reelrivals:tournament/set_mode
scoreboard players reset @a rr.mode
execute as @a[tag=rr_host,scores={rr.dur=1..}] run function reelrivals:tournament/set_dur
scoreboard players reset @a rr.dur
execute as @a[tag=rr_host,scores={rr.buyin=1..}] run function reelrivals:tournament/set_buyin
scoreboard players reset @a rr.buyin
execute as @a[tag=rr_host,scores={rr.split=1..}] run function reelrivals:tournament/set_split
scoreboard players reset @a rr.split
execute as @a[tag=rr_host,scores={rr.target=1..}] run function reelrivals:tournament/set_target
scoreboard players reset @a rr.target
execute as @a[tag=rr_host,scores={rr.gear=1..}] run function reelrivals:tournament/set_gear
scoreboard players reset @a rr.gear
execute as @a[tag=rr_host,scores={rr.start=1..}] run function reelrivals:tournament/start_click
scoreboard players reset @a rr.start
execute as @a[scores={rr.join=1..}] run function reelrivals:tournament/join
scoreboard players reset @a rr.join

# gear unlocks - shared base every angler walks
execute as @a[scores={rr.caught=10..},tag=!rr_u1] run function reelrivals:unlock/tier1
execute as @a[scores={rr.caught=50..},tag=!rr_u2] run function reelrivals:unlock/tier2
execute as @a[tag=rr_hw,tag=!rr_u2] run function reelrivals:unlock/tier2

# circuit track (tournament results): Champion's Rod -> Grandmaster's Rod
execute as @a[scores={rr.played=5..},tag=!rr_u3] run function reelrivals:unlock/tier3
execute as @a[scores={rr.wins=1..},tag=!rr_u3] run function reelrivals:unlock/tier3
execute as @a[scores={rr.wins=5..},tag=!rr_u9] run function reelrivals:unlock/grandmaster
execute as @a[scores={rr.wins=3..,rr.played=20..},tag=!rr_u9] run function reelrivals:unlock/grandmaster

# naturalist track (species + geography): Naturalist's Rod -> Legend Rod.
# The Naturalist's Rod fires from the reelrivals:naturalist advancement reward, not here.
# Legend now needs every species on the ledger plus a leviathan (15 kg+), not a catch count.
execute as @a[advancements={reelrivals:master_angler=true},tag=rr_hw2,tag=!rr_u5] run function reelrivals:unlock/legend

# the long grind: 100 / 500 / 1000 catches
execute as @a[scores={rr.caught=100..},tag=!rr_u4] run function reelrivals:unlock/bait4
execute as @a[scores={rr.caught=500..},tag=!rr_u6] run function reelrivals:unlock/bait5
execute as @a[scores={rr.caught=1000..},tag=!rr_u7] run function reelrivals:unlock/master_deep

# deliver queued payouts to online players
execute as @a[scores={rr.owed=1..}] run function reelrivals:tournament/payone_prep

# tournament state machine
execute if score #state rr.t matches 1 run function reelrivals:tournament/lobby_tick
execute if score #state rr.t matches 2 run function reelrivals:tournament/run_tick

# re-enable public triggers LAST so the unlocked state survives into the next tick
# (reset deletes the enabled flag - enabling before resetting locks everyone out)
scoreboard players enable @a rr.host
scoreboard players enable @a rr.join
scoreboard players enable @a rr.records
scoreboard players enable @a rr.help
scoreboard players enable @a rr.guide
scoreboard players enable @a rr.top
execute as @a[tag=rr_host] run scoreboard players enable @s rr.mode
execute as @a[tag=rr_host] run scoreboard players enable @s rr.dur
execute as @a[tag=rr_host] run scoreboard players enable @s rr.buyin
execute as @a[tag=rr_host] run scoreboard players enable @s rr.split
execute as @a[tag=rr_host] run scoreboard players enable @s rr.target
execute as @a[tag=rr_host] run scoreboard players enable @s rr.gear
execute as @a[tag=rr_host] run scoreboard players enable @s rr.start
