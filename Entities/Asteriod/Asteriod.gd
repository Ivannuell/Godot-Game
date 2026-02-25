class_name Asteroid
extends Node2D

export var resource_type := "minerals"
export var resource_amount := 500
export var max_miners := 1
signal destroyed


var claimed_by = []
var active_miners := []

var rot_speed = rand_range(0.001, 0.05)

func _ready():
	add_to_group('asteroids')
	add_to_group('damageable')
	randomize()
	$Sprite.frame = rand_range(1, $Sprite.hframes)


func _process(delta):
	rotation += rot_speed
	clamp(rotation, 0, PI)
	
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
	

func die():
	emit_signal("destroyed")
	queue_free()
