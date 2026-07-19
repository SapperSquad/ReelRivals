scoreboard players remove #ticks rr.t 1
execute if score #ticks rr.t matches ..0 run function reelrivals:tournament/end
execute if score #ticks rr.t matches ..0 run return 0
# once-per-second updates
scoreboard players operation #tmod rr.t = #ticks rr.t
scoreboard players operation #tmod rr.t %= #20 rr.const
execute if score #tmod rr.t matches 0 run function reelrivals:tournament/second
# feeding frenzy at the halfway mark, lasting 45 seconds
execute if score #frenzy rr.t matches 0 if score #ticks rr.t <= #halftick rr.t run function reelrivals:tournament/frenzy_start
execute if score #frenzy rr.t matches 1 if score #ticks rr.t <= #frenzyend rr.t run function reelrivals:tournament/frenzy_end
