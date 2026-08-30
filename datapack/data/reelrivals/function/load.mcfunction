# Reel Rivals — objectives, constants, storage, bossbar
scoreboard objectives add rr.t dummy
scoreboard objectives add rr.const dummy
scoreboard objectives add rr.w dummy
scoreboard objectives add rr.kg dummy
scoreboard objectives add rr.fr dummy
scoreboard objectives add rr.rec dummy
scoreboard objectives add rr.score dummy "Tournament Points"
scoreboard objectives add rr.caught dummy
scoreboard objectives add rr.played dummy
scoreboard objectives add rr.wins dummy
scoreboard objectives add rr.owed dummy
scoreboard objectives add rr.tmp dummy
scoreboard objectives add rr.reelt dummy
scoreboard objectives add rr.age dummy
scoreboard objectives add rr.host trigger
scoreboard objectives add rr.join trigger
scoreboard objectives add rr.records trigger
scoreboard objectives add rr.help trigger
scoreboard objectives add rr.mode trigger
scoreboard objectives add rr.dur trigger
scoreboard objectives add rr.buyin trigger
scoreboard objectives add rr.split trigger
scoreboard objectives add rr.start trigger
scoreboard objectives add rr.guide trigger
scoreboard objectives add rr.top trigger
scoreboard objectives add rr.target trigger
scoreboard objectives add rr.gear trigger
# 1.4.0: bounty board, fish market, angler's log
scoreboard objectives add rr.market trigger
scoreboard objectives add rr.sellall trigger
scoreboard objectives add rr.stats trigger
scoreboard objectives add rr.pb dummy
scoreboard objectives add rr.bounties dummy
scoreboard objectives add rr.sold dummy
scoreboard objectives modify rr.caught displayname [{"text":"Top Anglers ","color":"aqua","bold":true},{"text":"(catches)","color":"gray"}]
scoreboard players add #topshown rr.t 0
scoreboard players add #target rr.t 0
scoreboard players add #gear rr.t 0

# species -> tournament target-category membership (for specific-fish tournaments)
data merge storage reelrivals:cat {fresh:{cod:1b,salmon:1b,tropical:1b,puffer:1b,golden_bass:1b,copper_trout:1b,whiskered_catfish:1b,mudskip_gar:1b,lake_perch:1b,mirror_carp:1b,moonlit_koi:1b,swamp_lurker:1b,jungle_piranha:1b,midnight_eel:1b},salt:{cod:1b,salmon:1b,tropical:1b,puffer:1b,silver_herring:1b,sunfin_tuna:1b,storm_marlin:1b,thunderfin:1b,ember_snapper:1b,coral_empress:1b,frostfin_char:1b,glacier_pike:1b,deep_grouper:1b,abyssal_angler:1b,midnight_eel:1b},trophy:{king_sturgeon:1b,ancient_coelacanth:1b,void_skate:1b,emperor_arowana:1b,thunderfin:1b,coral_empress:1b,abyssal_angler:1b,storm_marlin:1b,whiskered_catfish:1b,mirror_carp:1b,deep_grouper:1b,sunfin_tuna:1b,glacier_pike:1b,swamp_lurker:1b}}

# constants
scoreboard players set #2 rr.const 2
scoreboard players set #4 rr.const 4
scoreboard players set #5 rr.const 5
scoreboard players set #10 rr.const 10
scoreboard players set #20 rr.const 20
scoreboard players set #60 rr.const 60

# global state
scoreboard players add #state rr.t 0
scoreboard players add #pot rr.t 0
scoreboard players add #last rr.t 0
scoreboard players add #frenzy rr.t 0

# 1.4.0 bounty/market tunables (admins may change these live)
scoreboard players add #bstart rr.t 0
scoreboard players add #bperiod rr.t 0
execute unless score #bperiod rr.t matches 1.. run scoreboard players set #bperiod rr.t 7
scoreboard players add #emper rr.t 0
execute unless score #emper rr.t matches 1.. run scoreboard players set #emper rr.t 1
scoreboard players add #bpick rr.t 0
# seed a bounty on first ever load (active:0b until bounty/rotate picks one)
execute unless data storage reelrivals:bounty active run data merge storage reelrivals:bounty {species:"",disp:"none",color:"gray",active:0b}

# record slates (weight in 0.1 kg units, plus display kg/fr and in-game day)
scoreboard players add #rec.cod rr.rec 0
scoreboard players add #rec.cod.kg rr.rec 0
scoreboard players add #rec.cod.fr rr.rec 0
scoreboard players add #rec.cod.day rr.rec 0
scoreboard players add #rec.salmon rr.rec 0
scoreboard players add #rec.salmon.kg rr.rec 0
scoreboard players add #rec.salmon.fr rr.rec 0
scoreboard players add #rec.salmon.day rr.rec 0
scoreboard players add #rec.tropical rr.rec 0
scoreboard players add #rec.tropical.kg rr.rec 0
scoreboard players add #rec.tropical.fr rr.rec 0
scoreboard players add #rec.tropical.day rr.rec 0
scoreboard players add #rec.puffer rr.rec 0
scoreboard players add #rec.puffer.kg rr.rec 0
scoreboard players add #rec.puffer.fr rr.rec 0
scoreboard players add #rec.puffer.day rr.rec 0
scoreboard players add #rec.golden_bass rr.rec 0
scoreboard players add #rec.golden_bass.kg rr.rec 0
scoreboard players add #rec.golden_bass.fr rr.rec 0
scoreboard players add #rec.golden_bass.day rr.rec 0
scoreboard players add #rec.midnight_eel rr.rec 0
scoreboard players add #rec.midnight_eel.kg rr.rec 0
scoreboard players add #rec.midnight_eel.fr rr.rec 0
scoreboard players add #rec.midnight_eel.day rr.rec 0
scoreboard players add #rec.storm_marlin rr.rec 0
scoreboard players add #rec.storm_marlin.kg rr.rec 0
scoreboard players add #rec.storm_marlin.fr rr.rec 0
scoreboard players add #rec.storm_marlin.day rr.rec 0
scoreboard players add #rec.frostfin_char rr.rec 0
scoreboard players add #rec.frostfin_char.kg rr.rec 0
scoreboard players add #rec.frostfin_char.fr rr.rec 0
scoreboard players add #rec.frostfin_char.day rr.rec 0
scoreboard players add #rec.ember_snapper rr.rec 0
scoreboard players add #rec.ember_snapper.kg rr.rec 0
scoreboard players add #rec.ember_snapper.fr rr.rec 0
scoreboard players add #rec.ember_snapper.day rr.rec 0
scoreboard players add #rec.swamp_lurker rr.rec 0
scoreboard players add #rec.swamp_lurker.kg rr.rec 0
scoreboard players add #rec.swamp_lurker.fr rr.rec 0
scoreboard players add #rec.swamp_lurker.day rr.rec 0
scoreboard players add #rec.jungle_piranha rr.rec 0
scoreboard players add #rec.jungle_piranha.kg rr.rec 0
scoreboard players add #rec.jungle_piranha.fr rr.rec 0
scoreboard players add #rec.jungle_piranha.day rr.rec 0
scoreboard players add #rec.king_sturgeon rr.rec 0
scoreboard players add #rec.king_sturgeon.kg rr.rec 0
scoreboard players add #rec.king_sturgeon.fr rr.rec 0
scoreboard players add #rec.king_sturgeon.day rr.rec 0

# tournament timer bossbar
bossbar add reelrivals:timer {"text":"Tournament"}
bossbar set reelrivals:timer color blue
bossbar set reelrivals:timer visible false

tellraw @a [{"text":"[Reel Rivals] ","color":"aqua"},{"text":"loaded. Type ","color":"gray"},{"text":"/trigger rr.help","color":"yellow"},{"text":" to get started.","color":"gray"}]

# expansion: new species record slates + lure conversion flag
scoreboard players add #conv rr.t 0
scoreboard players add #rec.copper_trout rr.rec 0
scoreboard players add #rec.copper_trout.kg rr.rec 0
scoreboard players add #rec.copper_trout.fr rr.rec 0
scoreboard players add #rec.copper_trout.day rr.rec 0
scoreboard players add #rec.whiskered_catfish rr.rec 0
scoreboard players add #rec.whiskered_catfish.kg rr.rec 0
scoreboard players add #rec.whiskered_catfish.fr rr.rec 0
scoreboard players add #rec.whiskered_catfish.day rr.rec 0
scoreboard players add #rec.lake_perch rr.rec 0
scoreboard players add #rec.lake_perch.kg rr.rec 0
scoreboard players add #rec.lake_perch.fr rr.rec 0
scoreboard players add #rec.lake_perch.day rr.rec 0
scoreboard players add #rec.mirror_carp rr.rec 0
scoreboard players add #rec.mirror_carp.kg rr.rec 0
scoreboard players add #rec.mirror_carp.fr rr.rec 0
scoreboard players add #rec.mirror_carp.day rr.rec 0
scoreboard players add #rec.moonlit_koi rr.rec 0
scoreboard players add #rec.moonlit_koi.kg rr.rec 0
scoreboard players add #rec.moonlit_koi.fr rr.rec 0
scoreboard players add #rec.moonlit_koi.day rr.rec 0
scoreboard players add #rec.silver_herring rr.rec 0
scoreboard players add #rec.silver_herring.kg rr.rec 0
scoreboard players add #rec.silver_herring.fr rr.rec 0
scoreboard players add #rec.silver_herring.day rr.rec 0
scoreboard players add #rec.deep_grouper rr.rec 0
scoreboard players add #rec.deep_grouper.kg rr.rec 0
scoreboard players add #rec.deep_grouper.fr rr.rec 0
scoreboard players add #rec.deep_grouper.day rr.rec 0
scoreboard players add #rec.sunfin_tuna rr.rec 0
scoreboard players add #rec.sunfin_tuna.kg rr.rec 0
scoreboard players add #rec.sunfin_tuna.fr rr.rec 0
scoreboard players add #rec.sunfin_tuna.day rr.rec 0
scoreboard players add #rec.abyssal_angler rr.rec 0
scoreboard players add #rec.abyssal_angler.kg rr.rec 0
scoreboard players add #rec.abyssal_angler.fr rr.rec 0
scoreboard players add #rec.abyssal_angler.day rr.rec 0

# expansion v3 slates
scoreboard players add #rec.mudskip_gar rr.rec 0
scoreboard players add #rec.mudskip_gar.kg rr.rec 0
scoreboard players add #rec.mudskip_gar.fr rr.rec 0
scoreboard players add #rec.mudskip_gar.day rr.rec 0
scoreboard players add #rec.thunderfin rr.rec 0
scoreboard players add #rec.thunderfin.kg rr.rec 0
scoreboard players add #rec.thunderfin.fr rr.rec 0
scoreboard players add #rec.thunderfin.day rr.rec 0
scoreboard players add #rec.glacier_pike rr.rec 0
scoreboard players add #rec.glacier_pike.kg rr.rec 0
scoreboard players add #rec.glacier_pike.fr rr.rec 0
scoreboard players add #rec.glacier_pike.day rr.rec 0
scoreboard players add #rec.coral_empress rr.rec 0
scoreboard players add #rec.coral_empress.kg rr.rec 0
scoreboard players add #rec.coral_empress.fr rr.rec 0
scoreboard players add #rec.coral_empress.day rr.rec 0
scoreboard players add #rec.emperor_arowana rr.rec 0
scoreboard players add #rec.emperor_arowana.kg rr.rec 0
scoreboard players add #rec.emperor_arowana.fr rr.rec 0
scoreboard players add #rec.emperor_arowana.day rr.rec 0
scoreboard players add #rec.void_skate rr.rec 0
scoreboard players add #rec.void_skate.kg rr.rec 0
scoreboard players add #rec.void_skate.fr rr.rec 0
scoreboard players add #rec.void_skate.day rr.rec 0
scoreboard players add #rec.ancient_coelacanth rr.rec 0
scoreboard players add #rec.ancient_coelacanth.kg rr.rec 0
scoreboard players add #rec.ancient_coelacanth.fr rr.rec 0
scoreboard players add #rec.ancient_coelacanth.day rr.rec 0

# 1.4.0: ensure a bounty is active (only rolls if none is set or the period elapsed)
function reelrivals:bounty/rotate
