class_name Asteroid
extends Node2D

enum Team {
	PLAYER,
	ENEMY,
	NEUTRAL
}

@export var team: Team = Team.PLAYER

@export var resource_type := "minerals"
@export var resource_amount := 500
@export var max_miners := 1


var multiplier = 1
var hits = 2

signal destroyed

var claimed_by = []
var active_miners := []

var rot_speed = randf_range(0.001, 0.05)

func _ready():
	add_to_group('asteroids')
	randomize()
	
	multiplier = randf_range(0.5, 2)
	
	resource_amount *= multiplier
	hits = ceil(hits * multiplier)
	$Sprite2D.set_scale(Vector2(multiplier, multiplier))
	$CollisionShape2D.set_scale(Vector2(multiplier, multiplier))
	#$NavigationObstacle2D.radius *= multiplier
	max_miners = max(1, int(multiplier))
	
	$Sprite2D.frame = randf_range(0, $Sprite2D.hframes)
	apply_separation()

func _physics_process(delta: float) -> void:
	pass

func _process(delta):
	rotation += rot_speed
	clamp(rotation, 0, PI)
	
func apply_separation():
	var push = Vector2.ZERO
	var min_dist = 32.0

	for other in get_parent().get_children():
		if other == self:
			continue

		var diff = global_position - other.global_position
		var dist = diff.length()

		if dist < min_dist and dist > 0:
			push += diff.normalized() * (min_dist - dist)

	global_position += push * 0.1
	
func mine(amount):
	var extracted = min(amount, resource_amount)
	resource_amount -= extracted

	if resource_amount <= 0:
		claimed_by = []
		die()

	return extracted
	
func is_claimed():
	return len(claimed_by) == max_miners
	
func claim(miner):
	claimed_by.append(miner)
	return true
	


func receive_damage(_damage_data):
	hits -= 1
	if hits <= 0:
		die()
		


func die():
	emit_signal("destroyed")
	queue_free()
