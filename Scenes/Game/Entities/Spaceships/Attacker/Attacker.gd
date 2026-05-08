extends Spaceship
class_name Attacker

@export var moving := true
var target: Node = null
var to_target := Vector2.ZERO
var target_rotation := 0.0

@onready var ui = $UIanchor 
@onready var word_label = $UIanchor/Control/word
@onready var word_highlight = $"UIanchor/Control/background-highlight"


var rotation_speed := 1.5

enum State {
	MOVING,
	TARGETING,
	SCOUTING
}

var current_State = State.MOVING

func _ready():
	avoidance_strength = 2.5
	SPEED = 100
	
	# Dodge behavior
	dodge_direction = 0  # -1 = left, 0 = none, 1 = right
	dodge_timer = 0.0
	dodge_duration = 1  # How long to commit to a dodge direction
	
	add_to_group(str(team))
	add_to_group("damageable")
	find_target()
	randomize()
		
	if team == Team.ENEMY:
		$AnimatedSprite2D.set_modulate(Color(0.95, 0.55, 0.55))
		word_label.text = str(index) + ". " + word
		word_highlight.visible = false
		ui.visible = false
		add_to_group("enemy_attackers")
		
	elif team == Team.PLAYER:
		ui.visible = false
		add_to_group("player_attackers")


func _physics_process(delta):
	$UIanchor.rotation = 0
	
	match current_State:
		State.MOVING:
			move_to_target(delta)
		State.SCOUTING:
			scouting(delta)
		State.TARGETING:
			targeting(delta)


	# Acquire target if needed
	if target == null or not is_instance_valid(target):
		find_target()
		return


	# --- Move Forward Based on Current Rotation ---
	if moving:
		var forward = Vector2.UP.rotated(rotation)
		set_velocity(forward * SPEED)
		move_and_slide()
		if to_target.length() <= 100:
			change_state(State.TARGETING)
		else:
			change_state(State.MOVING)
		

#region TypeAttack methods
func show_word():
	$UIanchor.visible = true

func hide_word():
	$UIanchor.visible = false

func update_index(i):
	index = i
	word_label.text = str(index) + ". " + word

func activate():
	word_label.add_theme_color_override("default_color", Color.GREEN)
	
func deactivate():
	word_label.add_theme_color_override("default_color", Color.WHITE)
#endregion



# MOVING TO TARGET
func move_to_target(delta):
	# Update dodge timer
	if dodge_timer > 0:
		dodge_timer -= delta
	else:
		dodge_timer = 0
		dodge_direction = 0
	
	# Acquire target if needed
	if target == null or not is_instance_valid(target):
		find_target()
		return
	
	to_target = target.global_position - global_position

	# Desired direction
	var desired = to_target.normalized()

	# Obstacle avoidance
	var avoid = get_avoidance_vector()

	# Blend
	var steering = (desired + avoid * avoidance_strength).normalized()

	# --- Smooth Rotation ---
	var target_angle = steering.angle() + PI/2
	var angle_diff = wrapf(target_angle - rotation, -PI, PI)
	rotation += clamp(angle_diff, -rotation_speed * delta, rotation_speed * delta)
	
	if to_target.length() <= 100:
		change_state(State.TARGETING)
	else:
		change_state(State.MOVING)
	
	
func scouting(delta):
	pass
	
	
func targeting(delta):
	# Acquire target if needed
	if target == null or not is_instance_valid(target):
		find_target()
		return
		
	target_rotation = global_position.angle_to_point(target.global_position)
	rotation = lerp_angle(rotation, target_rotation + PI / 2, rotation_speed * delta)



func change_state(new_state):
	if current_State == new_state:
		return

	# Do something before switching from a state

	current_State = new_state
	
	# Do something after switching to a new state



func _on_TargetTimer_timeout():
	find_target()

	if target == null:
		return

	var target_point := random_point_in_circle(target.global_position, 100.0)
	target_rotation = global_position.angle_to_point(target_point) - PI / 2


func find_target():
	var closest: Node = null
	var closest_dist := INF

	var opposite_group = get_opposite_team()

	for candidate in get_tree().get_nodes_in_group(str(opposite_group)):
		if not is_instance_valid(candidate):
			continue

		var dist := global_position.distance_to(candidate.global_position)

		if dist < closest_dist:
			closest = candidate
			closest_dist = dist

	target = closest
	if target:
		to_target = target.global_position - global_position


func get_opposite_team():
	return Team.PLAYER if team == Team.ENEMY else Team.ENEMY


func random_point_in_circle(center: Vector2, radius: float) -> Vector2:
	var u := randf()
	var theta := randf() * TAU
	var r := radius * sqrt(u)

	return center + Vector2(cos(theta), sin(theta)) * r


func toggle_moving():
	moving = !moving


func get_avoidance_vector():
	var avoid = Vector2.ZERO

	# Center detection - decide dodge direction
	if $RayCenter.is_colliding():
		if dodge_direction == 0:
			dodge_direction = 1
			dodge_timer = dodge_duration
		
		# Apply the chosen dodge direction
		if dodge_direction > 0:
			avoid += transform.x  # Dodge right
		else:
			avoid -= transform.x  # Dodge left
		
		avoid -= transform.y * 2.0  # Also push away from obstacle
	else:
		# Left side collision - steer right
		if $RayLeft.is_colliding():
			avoid -= transform.x
		if $RayLeft2.is_colliding():
			avoid -= transform.x
		if $RayLeft3.is_colliding():
			avoid -= transform.x
		
		
		# Right side collision - steer left
		if $RayRight.is_colliding():
			avoid += transform.x
		if $RayRight2.is_colliding():
			avoid += transform.x
		if $RayRight3.is_colliding():
			avoid += transform.x
			
		dodge_timer = dodge_duration

	return avoid
	
	
func receive_damage(damage_data):
	var health = get_node_or_null("Health")
	if health:
		health.apply_damage(damage_data)
	
	
func die():
	queue_free()
