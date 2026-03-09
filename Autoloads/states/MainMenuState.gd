extends "res://Autoloads/states/BaseState.gd"

func enter():
	SceneManager.change_scene("res://Scenes/Main_Menu/MainMenu.tscn")

func exit():
	print("Leaving main menu")
