extends "res://Autoloads/states/BaseState.gd"

func enter():
	SceneManager.change_scene_to_file("res://Scenes/Main_Menu/MainMenu.tscn")

func exit():
	print("Leaving main menu")
