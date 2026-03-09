extends Label


func _ready():
	GameStat.connect("player_mineral_changed", self, "on_minerals_changed")
	
func on_minerals_changed():
	text = str(GameStat.player_minerals).pad_zeros(6)
