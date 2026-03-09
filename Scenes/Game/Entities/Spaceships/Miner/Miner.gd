extends KinematicBody2D
class_name Miner

enum Team {
	PLAYER,
	ENEMY,
	NEUTRAL
}

export (Team) var team = Team.PLAYER

var target = null
onready var Cargo = $Cargo
onready var Base = $"../Base"

const SPEED = 100
export var turn_speed := 3.0
export var avoidance_strength := 2.5


var dodge_direction := 0  # -1 = left, 0 = none, 1 = right
var dodge_timer := 0.0
var dodge_duration := 1  # How long to commit to a dodge direction


onready var mining_tool = get_node_or_null("MiningTool")

enum State {
	SEARCHING,
	MOVING,
	MINING,
	RETURNING
}

var state = State.SEARCHING

func _ready():
	add_to_group(str(team))

func _physics_process(delta):
	match state:
		State.SEARCHING:
			find_target()

		State.MOVING:
			update_movement(delta, target)

		State.MINING:
			mine_target(delta)

		State.RETURNING:
			update_movement(delta, Base)


# =========================
# MOVEMENT
# =========================

func update_movement(delta, move_target):
	if move_target == null or not is_instance_valid(move_target):
		change_state(State.SEARCHING)
		return

	var to_target = move_target.global_position - global_position
	
	# If close enough
	if state == State.MOVING and to_target.length() <= 100:
		change_state(State.MINING)
		return
		
	if state == State.RETURNING and to_target.length() <= 10:
		Cargo.current = 0
		change_state(State.SEARCHING)
		return

	# Desired direction
	var desired = to_target.normalized()

	# Obstacle avoidance
	var avoid = get_avoidance_vector()

	# Blend
	var steering = (desired + avoid * avoidance_strength).normalized()

	# --- Smooth Rotation ---
	var target_angle = steering.angle() + PI/2
	var angle_diff = wrapf(target_angle - rotation, -PI, PI)
	rotation += clamp(angle_diff, -turn_speed * delta, turn_speed * delta)

	# --- Move Forward Based on Current Rotation ---
	var forward = Vector2.UP.rotated(rotation)
	move_and_slide(forward * SPEED)


# =========================
# OBSTACLE AVOIDANCE
# =========================

func get_avoidance_vector():
	var avoid = Vector2.ZERO

	# Center detection - decide dodge direction
	if $RayCenter.is_colliding():
		# If not already dodging, randomly choose left or right
		if dodge_direction == 0:
			dodge_direction = 1 if randf() > 0.5 else -1
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
		
		# Right side collision - steer left
		if $RayRight.is_colliding():
			avoid += transform.x

	return avoid


# =========================
# STATE LOGIC
# =========================

func change_state(new_state):
	if state == new_state:
		return

	if state == State.MINING and mining_tool:
		mining_tool.stop_beam()

	state = new_state

	if state == State.MINING and mining_tool:
		mining_tool.start_beam(target)


func find_target():
	if Cargo.current >= Cargo.capacity:
		change_state(State.RETURNING)
		return

	var closest = null
	var closest_dist = INF

	for asteroid in get_tree().get_nodes_in_group("asteroids"):
		if asteroid.is_claimed():
			continue

		var dist = global_position.distance_to(asteroid.global_position)

		if dist < closest_dist:
			closest = asteroid
			closest_dist = dist

	if closest and closest.claim(self):
		target = closest
		change_state(State.MOVING)


func mine_target(delta):
	if target == null or not is_instance_valid(target):
		change_state(State.SEARCHING)
		return

	var space_left = Cargo.capacity - Cargo.current

	if space_left <= 0:
		change_state(State.RETURNING)
		return

	var mined_amount = mining_tool.mine(delta, space_left)
	Cargo.current += mined_amount

	if mined_amount <= 0:
		target = null
		change_state(State.SEARCHING)

	if Cargo.current >= Cargo.capacity:
		change_state(State.RETURNING)

func receive_damage(damage_data):
	var health = get_node_or_null("Health")
	if health:
		health.apply_damage(damage_data)

func die():
	SignalBus.emit_signal("cargo_spawned", $Cargo)
	queue_free()
