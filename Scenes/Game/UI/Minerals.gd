extends Label

func _ready():
	#GameStat.connect("player_mineral_changed", Callable(self, "on_minerals_changed"))
	
	GameData.player_mineral_changed.connect(on_minerals_changed)
	
func on_minerals_changed():
	text = str(GameData.player_minerals).pad_zeros(5)
