extends Area2D

var max_asteroids := 20
onready var asteroid = preload("res://Scenes/Game/Entities/Asteriod/Asteriod.tscn")

var asteroid_radius := 20.0
var max_attempts := 20

func _ready():
	spawn_initial_asteroids()
	
func spawn_initial_asteroids():
	for i in range(max_asteroids):
		spawn_one()


func spawn_one():
	var area_radius = $Area.shape.radius * $Area.global_scale.x
	var ast = asteroid.instance()

	ast.global_position = find_valid_position(area_radius)

	ast.connect("destroyed", self, "_on_asteroid_destroyed", [ast])

	$Asteroids.add_child(ast)


func find_valid_position(area_radius):
	var asteroid_radius := 16.0
	var max_attempts := 20

	for attempt in range(max_attempts):
		var pos = random_point_in_circle(global_position, area_radius)

		if is_position_valid(pos, asteroid_radius):
			return pos

	# If we reach here, we failed to place after max attempts
	# That means area is probably too crowded

func is_position_valid(pos: Vector2, radius: float) -> bool:
	for child in $Asteroids.get_children():
		var other_radius = 16.0  # or get from asteroid itself
		var min_distance = radius + other_radius

		if pos.distance_to(child.global_position) < min_distance:
			return false

	return true
	
func _on_asteroid_destroyed(ast):
	spawn_one()

func random_point_in_circle(center: Vector2, radius: float) -> Vector2:
	var u := randf()
	var theta := randf() * TAU
	var r := radius * sqrt(u)

	return center + Vector2(cos(theta), sin(theta)) * r
