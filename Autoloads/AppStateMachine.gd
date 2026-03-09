extends Node

var current_state = null

var GameplayState = preload("res://Autoloads/states/GameplayState.gd")
var MainMenuState = preload("res://Autoloads/states/MainMenuState.gd")

func _ready():
	change_state(MainMenuState.new())

func change_state(new_state):
	if current_state:
		current_state.exit()

	current_state = new_state
	current_state.machine = self
	current_state.enter()

func _process(delta):
	if current_state:
		current_state.update(delta)
