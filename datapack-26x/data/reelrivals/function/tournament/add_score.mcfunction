# Runs as an entrant who just landed a weighed fish. #last rr.t = weight (0.1 kg units).
execute if score #mode rr.t matches 1 run scoreboard players operation @s rr.score += #last rr.t
execute if score #mode rr.t matches 2 run scoreboard players operation @s rr.score > #last rr.t
execute if score #mode rr.t matches 3 run scoreboard players add @s rr.score 1
