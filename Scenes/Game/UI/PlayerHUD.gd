extends CanvasLayer

onready var player_booster = $ProgressBar

func _ready():
	GameData.connect("player_mineral_changed", self, "on_minerals_changed")
	PlayerStats.connect("booster_fuel_changed", self, "on_booster_fuel_changed")
	
	player_booster.max_value = PlayerStats.max_boost_fuel
	player_booster.value = PlayerStats.max_boost_fuel
	
func on_minerals_changed():
	$Minerals.text = str(GameData.player_minerals).pad_zeros(6)
	
func on_booster_fuel_changed(value):
	player_booster.value = value
