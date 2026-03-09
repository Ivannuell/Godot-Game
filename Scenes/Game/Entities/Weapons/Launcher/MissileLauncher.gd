extends Node2D

var can_launch = true
export (PackedScene) var missile = preload("res://Scenes/Game/Entities/Projectiles/missile/Missile.tscn")
onready var team = get_parent().team

func _ready():
	pass

func _physics_process(delta):
	if Input.is_action_just_pressed('missile') and can_launch:
		print('missile launched')
		SignalBus.emit_signal("missile_launch", self)
		can_launch = false
		$Cooldown.start()

func _on_Timer_timeout():
	can_launch = true
	
