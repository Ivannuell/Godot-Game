extends CanvasLayer

@onready var player_booster = $ProgressBar
@onready var word_label = $Label

var active_word = ""
var update_word = false

#TODO: make the text reactive to the actual progress of the word

func _ready():
	GameData.connect("player_mineral_changed", Callable(self, "on_minerals_changed"))
	PlayerStats.connect("booster_fuel_changed", Callable(self, "on_booster_fuel_changed"))
	SignalBus.connect("activate_enemy", on_enemy_active)
	SignalBus.connect("no_enemy", on_no_active)
	
	player_booster.max_value = PlayerStats.max_boost_fuel
	player_booster.value = PlayerStats.max_boost_fuel
	
func _process(delta: float) -> void:
	if update_word:
		word_label.text = active_word
		update_word = false
	
func on_minerals_changed():
	$Minerals.text = str(GameData.player_minerals).pad_zeros(6)
	
func on_booster_fuel_changed(value):
	player_booster.value = value

func on_enemy_active(enemy):
	active_word = enemy.word
	update_word = true
	
func on_no_active():
	active_word = ""
	update_word = true
	
