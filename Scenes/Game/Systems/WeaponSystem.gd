extends Node

var AIM_INDICATOR = preload("res://Scenes/Game/Entities/Weapons/Launcher/aim_indicator/AimIndicator.tscn")

func _ready() -> void:
	SignalBus.connect('missile_aim', _on_missile_aim)


func _on_missile_aim(launcher):
	var aim = AIM_INDICATOR.instantiate()
	launcher.add_child(aim)
	
