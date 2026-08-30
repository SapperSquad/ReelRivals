# /trigger rr.sellall — sell every weighed fish in your inventory at a flat rate (fast, small discount).
# clear ... 0 counts matching items without removing them (provably correct, no inventory iteration).
scoreboard players set #n rr.tmp 0
execute store result score #n rr.tmp run clear @s *[minecraft:custom_data~{reelrivals:{weighed:1b}}] 0
execute if score #n rr.tmp matches ..0 run tellraw @s [{"text":"[Reel Rivals] ","color":"aqua"},{"text":"No weighed fish to sell.","color":"gray"}]
execute if score #n rr.tmp matches 1.. run function reelrivals:market/do_all
