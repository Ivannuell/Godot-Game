extends Node2D


export (PackedScene) onready var projectile
var cooldown := 0.0


func _physics_process(delta):
#	var cursor_dir = (get_global_mouse_position() - global_position).normalized()
	rotation = global_position.angle_to_point(get_global_mouse_position())
	cooldown += delta
	
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and cooldown >= 0.1:
		SignalBus.emit_signal("gun_shoot", self)
		cooldown = 0.0
