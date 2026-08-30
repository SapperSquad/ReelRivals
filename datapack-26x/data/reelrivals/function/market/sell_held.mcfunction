# /trigger rr.market — sell the weighed fish in your main hand, priced by its exact weight.
execute unless items entity @s weapon.mainhand *[minecraft:custom_data~{reelrivals:{weighed:1b}}] run tellraw @s [{"text":"[Reel Rivals] ","color":"aqua"},{"text":"Hold a weighed fish to sell it. ","color":"gray"},{"text":"Use /trigger rr.sellall to cash out your whole catch at once.","color":"dark_gray"}]
execute if items entity @s weapon.mainhand *[minecraft:custom_data~{reelrivals:{weighed:1b}}] run function reelrivals:market/do_held
