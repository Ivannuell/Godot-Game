extends Node2D


export (PackedScene) onready var projectile
var cooldown = 0
var is_shooting := false


func _physics_process(delta):
	rotation = global_position.angle_to_point(get_global_mouse_position())
	cooldown += delta
	
	if is_shooting and cooldown >= 0.2:
		SignalBus.emit_signal("gun_shoot", self)
		cooldown = 0.0
	
	
func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		is_shooting = event.pressed
	


