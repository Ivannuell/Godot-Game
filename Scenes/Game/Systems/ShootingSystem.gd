extends Node

func _ready():
	SignalBus.connect("gun_shoot", _on_gun_shot)
	SignalBus.connect("missile_launch", _on_missile_launch)

func _on_gun_shot(gun):
	var projectile = gun.projectile.instantiate()
	projectile._setup(gun)
	add_child(projectile)
	
func _on_missile_launch(launcher):
	var missile = launcher.missile.instantiate()
	missile._setup(launcher)
	add_child(missile)
