extends "res://Autoloads/states/BaseState.gd"

func enter():
	SceneManager.change_scene("res://Scenes/Game/Game.tscn")

func exit():
	print("Cleaning up gameplay state")
