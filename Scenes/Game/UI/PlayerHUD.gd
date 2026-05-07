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
	SignalBus.connect("enemy_word_update", on_update_word_visual)
	
	player_booster.max_value = PlayerStats.max_boost_fuel
	player_booster.value = PlayerStats.max_boost_fuel
	word_label.add_theme_font_size_override("normal_font_size", 32)

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


func on_update_word_visual(current_index):
	var typed = active_word.substr(0, current_index)
	var current = ""
	var remaining = ""
	
	if current_index < active_word.length():
		current = active_word[current_index]
	
	if current_index + 1 < active_word.length():
		remaining = active_word.substr(current_index + 1)
	
	word_label.text = (
		"[color=green]" + typed + "[/color]" +
		"[color=yellow]" + current + "[/color]" +
		remaining
	)
