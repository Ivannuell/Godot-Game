extends Area2D 

var target = null 
var asteroids_in_range = [] 
var resource_persec = 200 

onready var Cargo = get_parent().get_node('Cargo')

var beam_time := 0.0
var wobble_amplitude := 10.0
var wobble_speed := 12.0

func _process(delta): 
	if Cargo.current >= Cargo.capacity:
		$Line2D.clear_points() 
		return 
		
	target = _get_closest_asteroid() 

	if target == null or not is_instance_valid(target): 
		$Line2D.clear_points() 
		return 
		
	beam_time += delta

	var end_pos = to_local(target.global_position)

	# Get perpendicular direction
	var dir = end_pos.normalized()
	var perpendicular = Vector2(-dir.y, dir.x)

	# Sine wave offset
	var offset = perpendicular * sin(beam_time * wobble_speed) * wobble_amplitude

	$Line2D.points = [Vector2.ZERO, end_pos + offset]
	Cargo.current += target.mine(resource_persec * delta) 

func _on_MiningTool_Player_body_entered(body): 
	if body is Asteroid: 
		asteroids_in_range.append(body) 

func _on_MiningTool_Player_body_exited(body): 
	_remove_asteroid(body) 

func _get_closest_asteroid(): 
	var closest = null 
	var min_dist = INF 

	for asteroid in asteroids_in_range: 
		if not is_instance_valid(asteroid): 
			continue 
		var dist = global_position.distance_to(asteroid.global_position) 
		if dist < min_dist: 
			min_dist = dist 
			closest = asteroid 
			return closest 

func _remove_asteroid(asteroid): 
	if asteroid in asteroids_in_range: 
		asteroids_in_range.erase(asteroid) 

func random_point_in_circle(center: Vector2, radius: float) -> Vector2:
	var u := randf()
	var theta := randf() * TAU
	var r := radius * sqrt(u)

	return center + Vector2(cos(theta), sin(theta)) * r
