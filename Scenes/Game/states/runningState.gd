extends "res://Scenes/Game/states/gameplay_BaseState.gd"

func enter():
	game.get_tree().paused = false
	game.get_node("PauseLayer").visible = false
	print("Game Running")
	
	
func exit():
	pass
	
	
func update(delta):
	pass
