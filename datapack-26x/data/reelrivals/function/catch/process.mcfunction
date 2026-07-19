# Runs as the catching player, positioned at the fish (attributed by catch/scan to the reeler).
# Phase 1: offhand lure conversion of common catches. Phase 2: weigh + attribute every species.
scoreboard players set #conv rr.t 0

execute if items entity @s weapon.offhand *[minecraft:custom_data~{reelrivals:{lure:"golden_bass"}}] as @e[type=item,distance=..12] at @s if biome ~ ~ ~ #minecraft:is_river if items entity @s contents *[minecraft:custom_data~{reelrivals:{common:1b,unweighed:1b}}] run function reelrivals:lure/try {species:"golden_bass",chance:35,disp:"Golden Bass",color:"gold",cmd:"790001"}
execute if score #conv rr.t matches 1 run function reelrivals:lure/consume {species:"golden_bass",disp:"Gilded Spinner"}
execute if items entity @s weapon.offhand *[minecraft:custom_data~{reelrivals:{lure:"midnight_eel"}}] as @e[type=item,distance=..12] if items entity @s contents *[minecraft:custom_data~{reelrivals:{common:1b,unweighed:1b}}] run function reelrivals:lure/try {species:"midnight_eel",chance:35,disp:"Midnight Eel",color:"dark_purple",cmd:"790002"}
execute if score #conv rr.t matches 1 run function reelrivals:lure/consume {species:"midnight_eel",disp:"Nightcrawler"}
execute if items entity @s weapon.offhand *[minecraft:custom_data~{reelrivals:{lure:"storm_marlin"}}] as @e[type=item,distance=..12] at @s if biome ~ ~ ~ #minecraft:is_ocean if items entity @s contents *[minecraft:custom_data~{reelrivals:{common:1b,unweighed:1b}}] run function reelrivals:lure/try {species:"storm_marlin",chance:35,disp:"Storm Marlin",color:"blue",cmd:"790003"}
execute if score #conv rr.t matches 1 run function reelrivals:lure/consume {species:"storm_marlin",disp:"Storm Jig"}
execute if items entity @s weapon.offhand *[minecraft:custom_data~{reelrivals:{lure:"frostfin_char"}}] as @e[type=item,distance=..12] at @s if biome ~ ~ ~ #reelrivals:cold if items entity @s contents *[minecraft:custom_data~{reelrivals:{common:1b,unweighed:1b}}] run function reelrivals:lure/try {species:"frostfin_char",chance:35,disp:"Frostfin Char",color:"aqua",cmd:"790004"}
execute if score #conv rr.t matches 1 run function reelrivals:lure/consume {species:"frostfin_char",disp:"Frost Jig"}
execute if items entity @s weapon.offhand *[minecraft:custom_data~{reelrivals:{lure:"ember_snapper"}}] as @e[type=item,distance=..12] at @s if biome ~ ~ ~ #reelrivals:warm_ocean if items entity @s contents *[minecraft:custom_data~{reelrivals:{common:1b,unweighed:1b}}] run function reelrivals:lure/try {species:"ember_snapper",chance:35,disp:"Ember Snapper",color:"red",cmd:"790005"}
execute if score #conv rr.t matches 1 run function reelrivals:lure/consume {species:"ember_snapper",disp:"Ember Jig"}
execute if items entity @s weapon.offhand *[minecraft:custom_data~{reelrivals:{lure:"swamp_lurker"}}] as @e[type=item,distance=..12] at @s if biome ~ ~ ~ #reelrivals:swamp if items entity @s contents *[minecraft:custom_data~{reelrivals:{common:1b,unweighed:1b}}] run function reelrivals:lure/try {species:"swamp_lurker",chance:35,disp:"Swamp Lurker",color:"dark_green",cmd:"790006"}
execute if score #conv rr.t matches 1 run function reelrivals:lure/consume {species:"swamp_lurker",disp:"Bog Creeper"}
execute if items entity @s weapon.offhand *[minecraft:custom_data~{reelrivals:{lure:"jungle_piranha"}}] as @e[type=item,distance=..12] at @s if biome ~ ~ ~ #minecraft:is_jungle if items entity @s contents *[minecraft:custom_data~{reelrivals:{common:1b,unweighed:1b}}] run function reelrivals:lure/try {species:"jungle_piranha",chance:35,disp:"Jungle Piranha",color:"green",cmd:"790007"}
execute if score #conv rr.t matches 1 run function reelrivals:lure/consume {species:"jungle_piranha",disp:"Cocoa Popper"}
execute if items entity @s weapon.offhand *[minecraft:custom_data~{reelrivals:{lure:"king_sturgeon"}}] as @e[type=item,distance=..12] if items entity @s contents *[minecraft:custom_data~{reelrivals:{common:1b,unweighed:1b}}] run function reelrivals:lure/try {species:"king_sturgeon",chance:10,disp:"King Sturgeon",color:"gold",cmd:"790008"}
execute if score #conv rr.t matches 1 run function reelrivals:lure/consume {species:"king_sturgeon",disp:"King's Roe"}
execute if items entity @s weapon.offhand *[minecraft:custom_data~{reelrivals:{lure:"copper_trout"}}] as @e[type=item,distance=..12] at @s if biome ~ ~ ~ #minecraft:is_river if items entity @s contents *[minecraft:custom_data~{reelrivals:{common:1b,unweighed:1b}}] run function reelrivals:lure/try {species:"copper_trout",chance:35,disp:"Copper Trout",color:"#B87333",cmd:"790009"}
execute if score #conv rr.t matches 1 run function reelrivals:lure/consume {species:"copper_trout",disp:"Copper Spinner"}
execute if items entity @s weapon.offhand *[minecraft:custom_data~{reelrivals:{lure:"whiskered_catfish"}}] as @e[type=item,distance=..12] at @s if biome ~ ~ ~ #minecraft:is_river if items entity @s contents *[minecraft:custom_data~{reelrivals:{common:1b,unweighed:1b}}] run function reelrivals:lure/try {species:"whiskered_catfish",chance:35,disp:"Whiskered Catfish",color:"gray",cmd:"790010"}
execute if score #conv rr.t matches 1 run function reelrivals:lure/consume {species:"whiskered_catfish",disp:"Stink Bait"}
execute if items entity @s weapon.offhand *[minecraft:custom_data~{reelrivals:{lure:"lake_perch"}}] as @e[type=item,distance=..12] at @s unless biome ~ ~ ~ #minecraft:is_ocean unless biome ~ ~ ~ #minecraft:is_river unless biome ~ ~ ~ #reelrivals:swamp unless biome ~ ~ ~ #minecraft:is_jungle unless biome ~ ~ ~ #reelrivals:cold if items entity @s contents *[minecraft:custom_data~{reelrivals:{common:1b,unweighed:1b}}] run function reelrivals:lure/try {species:"lake_perch",chance:35,disp:"Lake Perch",color:"yellow",cmd:"790011"}
execute if score #conv rr.t matches 1 run function reelrivals:lure/consume {species:"lake_perch",disp:"Perch Popper"}
execute if items entity @s weapon.offhand *[minecraft:custom_data~{reelrivals:{lure:"mirror_carp"}}] as @e[type=item,distance=..12] at @s unless biome ~ ~ ~ #minecraft:is_ocean unless biome ~ ~ ~ #minecraft:is_river unless biome ~ ~ ~ #reelrivals:swamp unless biome ~ ~ ~ #minecraft:is_jungle unless biome ~ ~ ~ #reelrivals:cold if items entity @s contents *[minecraft:custom_data~{reelrivals:{common:1b,unweighed:1b}}] run function reelrivals:lure/try {species:"mirror_carp",chance:35,disp:"Mirror Carp",color:"white",cmd:"790012"}
execute if score #conv rr.t matches 1 run function reelrivals:lure/consume {species:"mirror_carp",disp:"Silver Spinner"}
execute if items entity @s weapon.offhand *[minecraft:custom_data~{reelrivals:{lure:"moonlit_koi"}}] as @e[type=item,distance=..12] at @s unless biome ~ ~ ~ #minecraft:is_ocean unless biome ~ ~ ~ #minecraft:is_river unless biome ~ ~ ~ #reelrivals:swamp unless biome ~ ~ ~ #minecraft:is_jungle unless biome ~ ~ ~ #reelrivals:cold if items entity @s contents *[minecraft:custom_data~{reelrivals:{common:1b,unweighed:1b}}] run function reelrivals:lure/try {species:"moonlit_koi",chance:35,disp:"Moonlit Koi",color:"light_purple",cmd:"790013"}
execute if score #conv rr.t matches 1 run function reelrivals:lure/consume {species:"moonlit_koi",disp:"Moon Popper"}
execute if items entity @s weapon.offhand *[minecraft:custom_data~{reelrivals:{lure:"silver_herring"}}] as @e[type=item,distance=..12] at @s if biome ~ ~ ~ #minecraft:is_ocean if items entity @s contents *[minecraft:custom_data~{reelrivals:{common:1b,unweighed:1b}}] run function reelrivals:lure/try {species:"silver_herring",chance:35,disp:"Silver Herring",color:"gray",cmd:"790014"}
execute if score #conv rr.t matches 1 run function reelrivals:lure/consume {species:"silver_herring",disp:"Herring Rig"}
execute if items entity @s weapon.offhand *[minecraft:custom_data~{reelrivals:{lure:"deep_grouper"}}] as @e[type=item,distance=..12] at @s if biome ~ ~ ~ #minecraft:is_deep_ocean if items entity @s contents *[minecraft:custom_data~{reelrivals:{common:1b,unweighed:1b}}] run function reelrivals:lure/try {species:"deep_grouper",chance:35,disp:"Deep Grouper",color:"dark_blue",cmd:"790015"}
execute if score #conv rr.t matches 1 run function reelrivals:lure/consume {species:"deep_grouper",disp:"Deep Jig"}
execute if items entity @s weapon.offhand *[minecraft:custom_data~{reelrivals:{lure:"sunfin_tuna"}}] as @e[type=item,distance=..12] at @s if biome ~ ~ ~ #minecraft:is_ocean if items entity @s contents *[minecraft:custom_data~{reelrivals:{common:1b,unweighed:1b}}] run function reelrivals:lure/try {species:"sunfin_tuna",chance:35,disp:"Sunfin Tuna",color:"yellow",cmd:"790016"}
execute if score #conv rr.t matches 1 run function reelrivals:lure/consume {species:"sunfin_tuna",disp:"Sunfin Spoon"}
execute if items entity @s weapon.offhand *[minecraft:custom_data~{reelrivals:{lure:"abyssal_angler"}}] as @e[type=item,distance=..12] at @s if biome ~ ~ ~ #minecraft:is_deep_ocean if items entity @s contents *[minecraft:custom_data~{reelrivals:{common:1b,unweighed:1b}}] run function reelrivals:lure/try {species:"abyssal_angler",chance:20,disp:"Abyssal Angler",color:"dark_purple",cmd:"790017"}
execute if score #conv rr.t matches 1 run function reelrivals:lure/consume {species:"abyssal_angler",disp:"Abyssal Beacon"}
execute if items entity @s weapon.offhand *[minecraft:custom_data~{reelrivals:{lure:"mudskip_gar"}}] as @e[type=item,distance=..12] at @s if biome ~ ~ ~ #minecraft:is_river if items entity @s contents *[minecraft:custom_data~{reelrivals:{common:1b,unweighed:1b}}] run function reelrivals:lure/try {species:"mudskip_gar",chance:35,disp:"Mudskip Gar",color:"#6B8E23",cmd:"790018"}
execute if score #conv rr.t matches 1 run function reelrivals:lure/consume {species:"mudskip_gar",disp:"Mud Dauber"}
execute if items entity @s weapon.offhand *[minecraft:custom_data~{reelrivals:{lure:"thunderfin"}}] as @e[type=item,distance=..12] at @s if biome ~ ~ ~ #minecraft:is_ocean if items entity @s contents *[minecraft:custom_data~{reelrivals:{common:1b,unweighed:1b}}] run function reelrivals:lure/try {species:"thunderfin",chance:30,disp:"Thunderfin",color:"yellow",cmd:"790019"}
execute if score #conv rr.t matches 1 run function reelrivals:lure/consume {species:"thunderfin",disp:"Thunder Jig"}
execute if items entity @s weapon.offhand *[minecraft:custom_data~{reelrivals:{lure:"glacier_pike"}}] as @e[type=item,distance=..12] at @s if biome ~ ~ ~ #reelrivals:cold if items entity @s contents *[minecraft:custom_data~{reelrivals:{common:1b,unweighed:1b}}] run function reelrivals:lure/try {species:"glacier_pike",chance:35,disp:"Glacier Pike",color:"#5F9EA0",cmd:"790020"}
execute if score #conv rr.t matches 1 run function reelrivals:lure/consume {species:"glacier_pike",disp:"Glacier Hook"}
execute if items entity @s weapon.offhand *[minecraft:custom_data~{reelrivals:{lure:"coral_empress"}}] as @e[type=item,distance=..12] at @s if biome ~ ~ ~ #reelrivals:warm_ocean if items entity @s contents *[minecraft:custom_data~{reelrivals:{common:1b,unweighed:1b}}] run function reelrivals:lure/try {species:"coral_empress",chance:30,disp:"Coral Empress",color:"#FF69B4",cmd:"790021"}
execute if score #conv rr.t matches 1 run function reelrivals:lure/consume {species:"coral_empress",disp:"Coral Charm"}
execute if items entity @s weapon.offhand *[minecraft:custom_data~{reelrivals:{lure:"emperor_arowana"}}] as @e[type=item,distance=..12] at @s if biome ~ ~ ~ #minecraft:is_jungle if items entity @s contents *[minecraft:custom_data~{reelrivals:{common:1b,unweighed:1b}}] run function reelrivals:lure/try {species:"emperor_arowana",chance:30,disp:"Emperor Arowana",color:"gold",cmd:"790022"}
execute if score #conv rr.t matches 1 run function reelrivals:lure/consume {species:"emperor_arowana",disp:"Royal Popper"}
execute if items entity @s weapon.offhand *[minecraft:custom_data~{reelrivals:{lure:"void_skate"}}] as @e[type=item,distance=..12] if dimension minecraft:the_end if items entity @s contents *[minecraft:custom_data~{reelrivals:{common:1b,unweighed:1b}}] run function reelrivals:lure/try {species:"void_skate",chance:25,disp:"Void Skate",color:"#C8A2C8",cmd:"790023"}
execute if score #conv rr.t matches 1 run function reelrivals:lure/consume {species:"void_skate",disp:"Void Line"}
execute if items entity @s weapon.offhand *[minecraft:custom_data~{reelrivals:{lure:"ancient_coelacanth"}}] as @e[type=item,distance=..12] at @s if biome ~ ~ ~ #minecraft:is_deep_ocean if items entity @s contents *[minecraft:custom_data~{reelrivals:{common:1b,unweighed:1b}}] run function reelrivals:lure/try {species:"ancient_coelacanth",chance:15,disp:"Ancient Coelacanth",color:"#8B4513",cmd:"790024"}
execute if score #conv rr.t matches 1 run function reelrivals:lure/consume {species:"ancient_coelacanth",disp:"Fossil Bait"}

scoreboard players set #last rr.t 0
execute as @e[type=item,distance=..12] if items entity @s contents *[minecraft:custom_data~{reelrivals:{unweighed:1b,species:"cod"}}] run function reelrivals:catch/weigh {species:"cod",min:4,max:25}
execute if score #last rr.t matches 1.. run function reelrivals:catch/score {species:"cod",disp:"Cod"}
scoreboard players set #last rr.t 0
execute as @e[type=item,distance=..12] if items entity @s contents *[minecraft:custom_data~{reelrivals:{unweighed:1b,species:"salmon"}}] run function reelrivals:catch/weigh {species:"salmon",min:8,max:40}
execute if score #last rr.t matches 1.. run function reelrivals:catch/score {species:"salmon",disp:"Salmon"}
scoreboard players set #last rr.t 0
execute as @e[type=item,distance=..12] if items entity @s contents *[minecraft:custom_data~{reelrivals:{unweighed:1b,species:"tropical"}}] run function reelrivals:catch/weigh {species:"tropical",min:1,max:5}
execute if score #last rr.t matches 1.. run function reelrivals:catch/score {species:"tropical",disp:"Tropical Fish"}
scoreboard players set #last rr.t 0
execute as @e[type=item,distance=..12] if items entity @s contents *[minecraft:custom_data~{reelrivals:{unweighed:1b,species:"puffer"}}] run function reelrivals:catch/weigh {species:"puffer",min:3,max:15}
execute if score #last rr.t matches 1.. run function reelrivals:catch/score {species:"puffer",disp:"Pufferfish"}
scoreboard players set #last rr.t 0
execute as @e[type=item,distance=..12] if items entity @s contents *[minecraft:custom_data~{reelrivals:{unweighed:1b,species:"golden_bass"}}] run function reelrivals:catch/weigh {species:"golden_bass",min:8,max:60}
execute if score #last rr.t matches 1.. run function reelrivals:catch/score {species:"golden_bass",disp:"Golden Bass"}
scoreboard players set #last rr.t 0
execute as @e[type=item,distance=..12] if items entity @s contents *[minecraft:custom_data~{reelrivals:{unweighed:1b,species:"midnight_eel"}}] run function reelrivals:catch/weigh {species:"midnight_eel",min:10,max:70}
execute if score #last rr.t matches 1.. run function reelrivals:catch/score {species:"midnight_eel",disp:"Midnight Eel"}
scoreboard players set #last rr.t 0
execute as @e[type=item,distance=..12] if items entity @s contents *[minecraft:custom_data~{reelrivals:{unweighed:1b,species:"storm_marlin"}}] run function reelrivals:catch/weigh {species:"storm_marlin",min:30,max:120}
execute if score #last rr.t matches 1.. run function reelrivals:catch/score {species:"storm_marlin",disp:"Storm Marlin"}
scoreboard players set #last rr.t 0
execute as @e[type=item,distance=..12] if items entity @s contents *[minecraft:custom_data~{reelrivals:{unweighed:1b,species:"frostfin_char"}}] run function reelrivals:catch/weigh {species:"frostfin_char",min:10,max:55}
execute if score #last rr.t matches 1.. run function reelrivals:catch/score {species:"frostfin_char",disp:"Frostfin Char"}
scoreboard players set #last rr.t 0
execute as @e[type=item,distance=..12] if items entity @s contents *[minecraft:custom_data~{reelrivals:{unweighed:1b,species:"ember_snapper"}}] run function reelrivals:catch/weigh {species:"ember_snapper",min:6,max:45}
execute if score #last rr.t matches 1.. run function reelrivals:catch/score {species:"ember_snapper",disp:"Ember Snapper"}
scoreboard players set #last rr.t 0
execute as @e[type=item,distance=..12] if items entity @s contents *[minecraft:custom_data~{reelrivals:{unweighed:1b,species:"swamp_lurker"}}] run function reelrivals:catch/weigh {species:"swamp_lurker",min:15,max:80}
execute if score #last rr.t matches 1.. run function reelrivals:catch/score {species:"swamp_lurker",disp:"Swamp Lurker"}
scoreboard players set #last rr.t 0
execute as @e[type=item,distance=..12] if items entity @s contents *[minecraft:custom_data~{reelrivals:{unweighed:1b,species:"jungle_piranha"}}] run function reelrivals:catch/weigh {species:"jungle_piranha",min:5,max:35}
execute if score #last rr.t matches 1.. run function reelrivals:catch/score {species:"jungle_piranha",disp:"Jungle Piranha"}
scoreboard players set #last rr.t 0
execute as @e[type=item,distance=..12] if items entity @s contents *[minecraft:custom_data~{reelrivals:{unweighed:1b,species:"king_sturgeon"}}] run function reelrivals:catch/weigh {species:"king_sturgeon",min:80,max:250}
execute if score #last rr.t matches 1.. run function reelrivals:catch/score {species:"king_sturgeon",disp:"King Sturgeon"}
scoreboard players set #last rr.t 0
execute as @e[type=item,distance=..12] if items entity @s contents *[minecraft:custom_data~{reelrivals:{unweighed:1b,species:"copper_trout"}}] run function reelrivals:catch/weigh {species:"copper_trout",min:6,max:35}
execute if score #last rr.t matches 1.. run function reelrivals:catch/score {species:"copper_trout",disp:"Copper Trout"}
scoreboard players set #last rr.t 0
execute as @e[type=item,distance=..12] if items entity @s contents *[minecraft:custom_data~{reelrivals:{unweighed:1b,species:"whiskered_catfish"}}] run function reelrivals:catch/weigh {species:"whiskered_catfish",min:20,max:90}
execute if score #last rr.t matches 1.. run function reelrivals:catch/score {species:"whiskered_catfish",disp:"Whiskered Catfish"}
scoreboard players set #last rr.t 0
execute as @e[type=item,distance=..12] if items entity @s contents *[minecraft:custom_data~{reelrivals:{unweighed:1b,species:"lake_perch"}}] run function reelrivals:catch/weigh {species:"lake_perch",min:5,max:30}
execute if score #last rr.t matches 1.. run function reelrivals:catch/score {species:"lake_perch",disp:"Lake Perch"}
scoreboard players set #last rr.t 0
execute as @e[type=item,distance=..12] if items entity @s contents *[minecraft:custom_data~{reelrivals:{unweighed:1b,species:"mirror_carp"}}] run function reelrivals:catch/weigh {species:"mirror_carp",min:15,max:85}
execute if score #last rr.t matches 1.. run function reelrivals:catch/score {species:"mirror_carp",disp:"Mirror Carp"}
scoreboard players set #last rr.t 0
execute as @e[type=item,distance=..12] if items entity @s contents *[minecraft:custom_data~{reelrivals:{unweighed:1b,species:"moonlit_koi"}}] run function reelrivals:catch/weigh {species:"moonlit_koi",min:8,max:50}
execute if score #last rr.t matches 1.. run function reelrivals:catch/score {species:"moonlit_koi",disp:"Moonlit Koi"}
scoreboard players set #last rr.t 0
execute as @e[type=item,distance=..12] if items entity @s contents *[minecraft:custom_data~{reelrivals:{unweighed:1b,species:"silver_herring"}}] run function reelrivals:catch/weigh {species:"silver_herring",min:3,max:20}
execute if score #last rr.t matches 1.. run function reelrivals:catch/score {species:"silver_herring",disp:"Silver Herring"}
scoreboard players set #last rr.t 0
execute as @e[type=item,distance=..12] if items entity @s contents *[minecraft:custom_data~{reelrivals:{unweighed:1b,species:"deep_grouper"}}] run function reelrivals:catch/weigh {species:"deep_grouper",min:25,max:110}
execute if score #last rr.t matches 1.. run function reelrivals:catch/score {species:"deep_grouper",disp:"Deep Grouper"}
scoreboard players set #last rr.t 0
execute as @e[type=item,distance=..12] if items entity @s contents *[minecraft:custom_data~{reelrivals:{unweighed:1b,species:"sunfin_tuna"}}] run function reelrivals:catch/weigh {species:"sunfin_tuna",min:30,max:130}
execute if score #last rr.t matches 1.. run function reelrivals:catch/score {species:"sunfin_tuna",disp:"Sunfin Tuna"}
scoreboard players set #last rr.t 0
execute as @e[type=item,distance=..12] if items entity @s contents *[minecraft:custom_data~{reelrivals:{unweighed:1b,species:"abyssal_angler"}}] run function reelrivals:catch/weigh {species:"abyssal_angler",min:15,max:60}
execute if score #last rr.t matches 1.. run function reelrivals:catch/score {species:"abyssal_angler",disp:"Abyssal Angler"}
scoreboard players set #last rr.t 0
execute as @e[type=item,distance=..12] if items entity @s contents *[minecraft:custom_data~{reelrivals:{unweighed:1b,species:"mudskip_gar"}}] run function reelrivals:catch/weigh {species:"mudskip_gar",min:20,max:70}
execute if score #last rr.t matches 1.. run function reelrivals:catch/score {species:"mudskip_gar",disp:"Mudskip Gar"}
scoreboard players set #last rr.t 0
execute as @e[type=item,distance=..12] if items entity @s contents *[minecraft:custom_data~{reelrivals:{unweighed:1b,species:"thunderfin"}}] run function reelrivals:catch/weigh {species:"thunderfin",min:40,max:140}
execute if score #last rr.t matches 1.. run function reelrivals:catch/score {species:"thunderfin",disp:"Thunderfin"}
scoreboard players set #last rr.t 0
execute as @e[type=item,distance=..12] if items entity @s contents *[minecraft:custom_data~{reelrivals:{unweighed:1b,species:"glacier_pike"}}] run function reelrivals:catch/weigh {species:"glacier_pike",min:30,max:100}
execute if score #last rr.t matches 1.. run function reelrivals:catch/score {species:"glacier_pike",disp:"Glacier Pike"}
scoreboard players set #last rr.t 0
execute as @e[type=item,distance=..12] if items entity @s contents *[minecraft:custom_data~{reelrivals:{unweighed:1b,species:"coral_empress"}}] run function reelrivals:catch/weigh {species:"coral_empress",min:20,max:80}
execute if score #last rr.t matches 1.. run function reelrivals:catch/score {species:"coral_empress",disp:"Coral Empress"}
scoreboard players set #last rr.t 0
execute as @e[type=item,distance=..12] if items entity @s contents *[minecraft:custom_data~{reelrivals:{unweighed:1b,species:"emperor_arowana"}}] run function reelrivals:catch/weigh {species:"emperor_arowana",min:30,max:90}
execute if score #last rr.t matches 1.. run function reelrivals:catch/score {species:"emperor_arowana",disp:"Emperor Arowana"}
scoreboard players set #last rr.t 0
execute as @e[type=item,distance=..12] if items entity @s contents *[minecraft:custom_data~{reelrivals:{unweighed:1b,species:"void_skate"}}] run function reelrivals:catch/weigh {species:"void_skate",min:50,max:150}
execute if score #last rr.t matches 1.. run function reelrivals:catch/score {species:"void_skate",disp:"Void Skate"}
scoreboard players set #last rr.t 0
execute as @e[type=item,distance=..12] if items entity @s contents *[minecraft:custom_data~{reelrivals:{unweighed:1b,species:"ancient_coelacanth"}}] run function reelrivals:catch/weigh {species:"ancient_coelacanth",min:100,max:200}
execute if score #last rr.t matches 1.. run function reelrivals:catch/score {species:"ancient_coelacanth",disp:"Ancient Coelacanth"}
scoreboard players set #last rr.t 0
