# Macro. Runs as the catching player. Args: species, disp. #last rr.t holds the weight.
scoreboard players add @s rr.caught 1

# personal best weight (0.1-kg units) for the Angler's Log
execute if score #last rr.t > @s rr.pb run scoreboard players operation @s rr.pb = #last rr.t

# heavyweight milestone: any single catch of 10.0 kg or more
execute if score #last rr.t matches 100.. run advancement grant @s only reelrivals:heavyweight
execute if score #last rr.t matches 100.. run tag @s add rr_hw
# leviathan milestone: 15.0 kg or more (gates the Legend Rod)
execute if score #last rr.t matches 150.. run advancement grant @s only reelrivals:leviathan
execute if score #last rr.t matches 150.. run tag @s add rr_hw2

# display weight (kg . tenths) for feedback + record
scoreboard players operation #dkg rr.t = #last rr.t
scoreboard players operation #dkg rr.t /= #10 rr.const
scoreboard players operation #dfr rr.t = #last rr.t
scoreboard players operation #dfr rr.t %= #10 rr.const

# server record check
$execute if score #last rr.t > #rec.$(species) rr.rec run function reelrivals:catch/record {species:"$(species)",disp:"$(disp)"}

# bounty board: is this the active bounty species?
$execute if data storage reelrivals:bounty {species:"$(species)",active:1b} run function reelrivals:bounty/hit {disp:"$(disp)"}

# tournament scoring (only if the catch counts toward this tournament's target + gear rules)
scoreboard players set #counts rr.t 1
$execute if score #state rr.t matches 2 if entity @s[tag=rr_entrant] run function reelrivals:tournament/eligible {species:"$(species)"}
execute if score #state rr.t matches 2 if entity @s[tag=rr_entrant] if score #counts rr.t matches 1 run function reelrivals:tournament/add_score

# catch feedback actionbar (every catch) + subtle sound
$execute if score #state rr.t matches 2 if entity @s[tag=rr_entrant] if score #counts rr.t matches 1 run function reelrivals:catch/feedback_t {disp:"$(disp)"}
$execute unless entity @s[tag=rr_entrant] run function reelrivals:catch/feedback {disp:"$(disp)"}
$execute if entity @s[tag=rr_entrant] unless score #state rr.t matches 2 run function reelrivals:catch/feedback {disp:"$(disp)"}
$execute if score #state rr.t matches 2 if entity @s[tag=rr_entrant] if score #counts rr.t matches 0 run function reelrivals:catch/feedback {disp:"$(disp)"}
execute at @s run playsound minecraft:entity.experience_orb.pickup player @s ~ ~ ~ 0.4 1.7
