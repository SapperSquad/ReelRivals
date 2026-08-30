# Macro. Arg: fs (the held fish's species). Doubles #emv if it's the active bounty species.
$execute if data storage reelrivals:bounty {species:"$(fs)",active:1b} run scoreboard players operation #emv rr.t *= #2 rr.const
