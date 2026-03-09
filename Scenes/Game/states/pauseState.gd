extends "res://Scenes/Game/states/gameplay_BaseState.gd"


func enter():
	game.get_tree().paused = true
	game.get_node('PauseLayer').visible = true
	print("Game Paused")

