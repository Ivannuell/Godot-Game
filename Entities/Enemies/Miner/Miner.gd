extends KinematicBody2D
class_name Miner

var target = null
onready var Cargo = $Cargo
var Base = null

const SPEED = 100
export var turn_speed := 3.0
export var avoidance_strength := 2.5
export(String) var team = ""

onready var mining_tool = get_node_or_null("MiningTool")

enum State {
	SEARCHING,
	MOVING,
	MINING,
	RETURNING
}

var state = State.SEARCHING


func _ready():
	add_to_group(team)
	Base = $"../../PlayerBase" if team == "Allies" else $"../../EnemyBase"


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

	if $RayCenter.is_colliding():
		avoid -= transform.y * 1.5

	if $RayLeft.is_colliding():
		avoid += transform.x

	if $RayRight.is_colliding():
		avoid -= transform.x

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
