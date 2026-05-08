extends Node2D


const FIRE_RATE = 0.2
const OVERHEAT_COOLDOWN = 1
const MAGAZINE_MAX = 10


@export var projectile: PackedScene
var cooldown = 0
var magazine = 5
var overheat = 0
var is_shooting := false


func _physics_process(delta):
	#rotation = global_position.angle_to_point(get_global_mouse_position()) - PI
	var dir = get_global_mouse_position() - global_position
	rotation = dir.angle() + PI
	cooldown += delta
		
	if is_shooting and cooldown >= FIRE_RATE and magazine > 0:
		SignalBus.emit_signal("gun_shoot", self)
		cooldown = 0.0
		magazine -= 1
		
	if magazine <= 0:
		overheat += delta
		
	if overheat >= OVERHEAT_COOLDOWN:
		magazine = MAGAZINE_MAX
		overheat = 0


func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		is_shooting = event.pressed
	
