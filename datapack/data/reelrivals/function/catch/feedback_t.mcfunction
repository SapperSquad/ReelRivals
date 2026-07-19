# Macro. Runs as the catching player during a tournament. Arg: disp.
# Shows fish + weight + this player's current tournament score.
$title @s actionbar [{"text":"$(disp) ","color":"aqua"},{"score":{"name":"#dkg","objective":"rr.t"},"color":"white"},{"text":".","color":"white"},{"score":{"name":"#dfr","objective":"rr.t"},"color":"white"},{"text":" kg","color":"gray"},{"text":"   Your score: ","color":"green"},{"score":{"name":"@s","objective":"rr.score"},"color":"gold","bold":true}]
