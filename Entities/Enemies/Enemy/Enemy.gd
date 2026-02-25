extends KinematicBody2D
class_name Enemy

export(String) var team = "Enemies"
export var moving := true

var target: Node = null
var target_rotation := 0.0

var rotation_speed := 8.0
var speed := 100.0


func _ready():
	add_to_group(team)
	add_to_group("damageable")
	find_target()


func _physics_process(delta):
	if target == null or not is_instance_valid(target):
		return
	
	rotation = lerp_angle(rotation, target_rotation, rotation_speed * delta)

	var forward := Vector2.UP.rotated(rotation)
	if global_position.distance_to(target.global_position) <= 100:
		rotation = lerp_angle(rotation, target_rotation + PI / 2, rotation_speed * delta)

	if moving:
		move_and_slide(forward * speed)


func _on_TargetTimer_timeout():
	find_target()

	if target == null:
		return

	var target_point := random_point_in_circle(target.global_position, 100.0)
	target_rotation = global_position.angle_to_point(target_point) - PI / 2


func find_target():
	var closest: Node = null
	var closest_dist := INF

	var opposite_group := get_opposite_team()

	for candidate in get_tree().get_nodes_in_group(opposite_group):
		if not is_instance_valid(candidate):
			continue

		var dist := global_position.distance_to(candidate.global_position)

		if dist < closest_dist:
			closest = candidate
			closest_dist = dist

	target = closest


func get_opposite_team() -> String:
	return "Allies" if team == "Enemies" else "Enemies"


func random_point_in_circle(center: Vector2, radius: float) -> Vector2:
	var u := randf()
	var theta := randf() * TAU
	var r := radius * sqrt(u)

	return center + Vector2(cos(theta), sin(theta)) * r


func toggle_moving():
	moving = !moving
