execute if score @s rr.score > #best rr.t run tag @a remove rr_lead
execute if score @s rr.score > #best rr.t run tag @s add rr_lead
execute if score @s rr.score > #best rr.t run scoreboard players operation #best rr.t = @s rr.score
