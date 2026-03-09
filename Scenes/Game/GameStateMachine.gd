extends Node


const RUNNING_STATE = preload("res://Scenes/Game/states/runningState.gd")
const PAUSE_STATE = preload("res://Scenes/Game/states/pauseState.gd")

onready var game = get_parent()

var current_state = null

func _ready():
	change_state(RUNNING_STATE.new())


func change_state(new_state):
	if current_state:
		current_state.exit()
		
	current_state = new_state
	current_state.machine = self
	current_state.game = game
	
	current_state.enter()


func _process(delta):
	if current_state:
		current_state.update(delta)
