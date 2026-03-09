extends Node2D

var asteroids_in_range = []

var resource_persec = 200

var target = null
var beam_active = false

var beam_time := 0.0
var wobble_amplitude := 10.0
var wobble_speed := 12.0

func start_beam(new_target):
	target = new_target
	beam_active = true
	show()

func stop_beam():
	beam_active = false
	target = null
	hide()
	$Line2D.points.clear()

func _process(delta):
	if not beam_active:
		return

	if target == null or not is_instance_valid(target):
		stop_beam()
		return

	beam_time += delta

	var end_pos = to_local(target.global_position)

	# Get perpendicular direction
	var dir = end_pos.normalized()
	var perpendicular = Vector2(-dir.y, dir.x)

	# Sine wave offset
	var offset = perpendicular * sin(beam_time * wobble_speed) * wobble_amplitude

	$Line2D.points = [Vector2.ZERO, end_pos + offset]
	
func mine(delta, cargo_space_available):
	if target == null or not is_instance_valid(target):
		stop_beam()
		return 0

	var request = min(resource_persec * delta, cargo_space_available)
	return target.mine(request)
	
func random_point_in_circle(center: Vector2, radius: float) -> Vector2:
	var u := randf()
	var theta := randf() * TAU
	var r := radius * sqrt(u)

	return center + Vector2(cos(theta), sin(theta)) * r
