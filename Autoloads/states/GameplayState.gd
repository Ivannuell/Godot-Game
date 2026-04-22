extends "res://Autoloads/states/BaseState.gd"

func enter():
	SceneManager.change_scene_to_file("res://Scenes/Game/Layers/Game/Game.tscn")

func exit():
	print("Cleaning up gameplay state")
