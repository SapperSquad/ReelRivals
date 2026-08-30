# Pick a new bounty species (1..28), avoiding an immediate repeat, and announce it.
scoreboard players operation #prev rr.t = #bpick rr.t
execute store result score #bpick rr.t run random value 1..28
execute if score #bpick rr.t = #prev rr.t run scoreboard players add #bpick rr.t 1
execute if score #bpick rr.t matches 29 run scoreboard players set #bpick rr.t 1

# index -> species. active:1b marks a live bounty. (Colors match the record ledger.)
execute if score #bpick rr.t matches 1 run data merge storage reelrivals:bounty {species:"cod",disp:"Cod",color:"white",active:1b}
execute if score #bpick rr.t matches 2 run data merge storage reelrivals:bounty {species:"salmon",disp:"Salmon",color:"white",active:1b}
execute if score #bpick rr.t matches 3 run data merge storage reelrivals:bounty {species:"tropical",disp:"Tropical Fish",color:"white",active:1b}
execute if score #bpick rr.t matches 4 run data merge storage reelrivals:bounty {species:"puffer",disp:"Pufferfish",color:"white",active:1b}
execute if score #bpick rr.t matches 5 run data merge storage reelrivals:bounty {species:"golden_bass",disp:"Golden Bass",color:"gold",active:1b}
execute if score #bpick rr.t matches 6 run data merge storage reelrivals:bounty {species:"copper_trout",disp:"Copper Trout",color:"#B87333",active:1b}
execute if score #bpick rr.t matches 7 run data merge storage reelrivals:bounty {species:"whiskered_catfish",disp:"Whiskered Catfish",color:"gray",active:1b}
execute if score #bpick rr.t matches 8 run data merge storage reelrivals:bounty {species:"mudskip_gar",disp:"Mudskip Gar",color:"#6B8E23",active:1b}
execute if score #bpick rr.t matches 9 run data merge storage reelrivals:bounty {species:"lake_perch",disp:"Lake Perch",color:"yellow",active:1b}
execute if score #bpick rr.t matches 10 run data merge storage reelrivals:bounty {species:"mirror_carp",disp:"Mirror Carp",color:"gray",active:1b}
execute if score #bpick rr.t matches 11 run data merge storage reelrivals:bounty {species:"moonlit_koi",disp:"Moonlit Koi",color:"light_purple",active:1b}
execute if score #bpick rr.t matches 12 run data merge storage reelrivals:bounty {species:"silver_herring",disp:"Silver Herring",color:"gray",active:1b}
execute if score #bpick rr.t matches 13 run data merge storage reelrivals:bounty {species:"sunfin_tuna",disp:"Sunfin Tuna",color:"yellow",active:1b}
execute if score #bpick rr.t matches 14 run data merge storage reelrivals:bounty {species:"storm_marlin",disp:"Storm Marlin",color:"blue",active:1b}
execute if score #bpick rr.t matches 15 run data merge storage reelrivals:bounty {species:"thunderfin",disp:"Thunderfin",color:"yellow",active:1b}
execute if score #bpick rr.t matches 16 run data merge storage reelrivals:bounty {species:"ember_snapper",disp:"Ember Snapper",color:"red",active:1b}
execute if score #bpick rr.t matches 17 run data merge storage reelrivals:bounty {species:"coral_empress",disp:"Coral Empress",color:"#FF69B4",active:1b}
execute if score #bpick rr.t matches 18 run data merge storage reelrivals:bounty {species:"frostfin_char",disp:"Frostfin Char",color:"aqua",active:1b}
execute if score #bpick rr.t matches 19 run data merge storage reelrivals:bounty {species:"glacier_pike",disp:"Glacier Pike",color:"#5F9EA0",active:1b}
execute if score #bpick rr.t matches 20 run data merge storage reelrivals:bounty {species:"deep_grouper",disp:"Deep Grouper",color:"dark_blue",active:1b}
execute if score #bpick rr.t matches 21 run data merge storage reelrivals:bounty {species:"abyssal_angler",disp:"Abyssal Angler",color:"dark_purple",active:1b}
execute if score #bpick rr.t matches 22 run data merge storage reelrivals:bounty {species:"ancient_coelacanth",disp:"Ancient Coelacanth",color:"#8B4513",active:1b}
execute if score #bpick rr.t matches 23 run data merge storage reelrivals:bounty {species:"swamp_lurker",disp:"Swamp Lurker",color:"dark_green",active:1b}
execute if score #bpick rr.t matches 24 run data merge storage reelrivals:bounty {species:"jungle_piranha",disp:"Jungle Piranha",color:"green",active:1b}
execute if score #bpick rr.t matches 25 run data merge storage reelrivals:bounty {species:"emperor_arowana",disp:"Emperor Arowana",color:"gold",active:1b}
execute if score #bpick rr.t matches 26 run data merge storage reelrivals:bounty {species:"void_skate",disp:"Void Skate",color:"#C8A2C8",active:1b}
execute if score #bpick rr.t matches 27 run data merge storage reelrivals:bounty {species:"midnight_eel",disp:"Midnight Eel",color:"dark_purple",active:1b}
execute if score #bpick rr.t matches 28 run data merge storage reelrivals:bounty {species:"king_sturgeon",disp:"King Sturgeon",color:"gold",active:1b}

# new rotation: reset per-player claims, stamp the start day
tag @a remove rr_bounty_claimed
execute store result score #bstart rr.t run time query day

# announce
tellraw @a [{"text":"==============================","color":"gold"}]
tellraw @a [{"text":"[Reel Rivals] ","color":"aqua"},{"text":"NEW BOUNTY: ","color":"gold","bold":true},{"nbt":"disp","storage":"reelrivals:bounty","color":"yellow","bold":true}]
tellraw @a [{"text":"  Land it to claim ","color":"gray"},{"text":"16 emeralds","color":"green"},{"text":", and it sells for ","color":"gray"},{"text":"double","color":"gold"},{"text":" at the market this rotation.","color":"gray"}]
tellraw @a [{"text":"==============================","color":"gold"}]
execute if entity @a[limit=1] run playsound minecraft:entity.player.levelup master @a ~ ~ ~ 0.7 1.2
