# Macro. Arg n = rank number. Finds the highest-scoring unranked entrant.
scoreboard players set #best rr.t -2147483648
tag @a remove rr_lead
execute as @a[tag=rr_entrant,tag=!rr_ranked] run function reelrivals:tournament/rank_check
$execute as @a[tag=rr_lead,limit=1] run tag @s add rr_rank$(n)
execute as @a[tag=rr_lead] run tag @s add rr_ranked
tag @a remove rr_lead
