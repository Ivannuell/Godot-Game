extends Node

var active_projectiles = {}

func _ready():
	SignalBus.connect("gun_shoot", self, "_on_gun_shot")

func _on_gun_shot(gun):
	var projectile = gun.projectile.instance()
	projectile._setup(gun)
	add_child(projectile)
