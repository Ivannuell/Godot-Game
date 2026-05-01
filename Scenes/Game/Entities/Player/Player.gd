extends CharacterBody2D
class_name Player

enum Team {
	PLAYER,
	ENEMY,
	NEUTRAL
}

@export var team: Team = Team.PLAYER

const MAX_SPEED := 200.0
const ACCELERATION := 400.0
const FRICTION := 200.0
const ROTATION_SPEED := 2  # radians per second

var target_multi = 1.0
var speed_up_multi = 1.0
var rotation_multi = 1.0

var aiming = false

var boost_available := true
@onready var engine_particles = $ThrusterParticles
@onready var agent = $NavigationAgent2D
var speed = 500

var curr_anim = 'idle'
var anim = ''

func _ready():
	add_to_group(str(team))



func _physics_process(delta):
	if agent.is_navigation_finished():
		velocity = Vector2.ZERO
		return

	var next_point = agent.get_next_path_position()
	var desired_velocity = (next_point - global_position).normalized() * speed
	
	agent.set_velocity(desired_velocity)
	
	rotation = lerp_angle(
			rotation, velocity.angle() + PI/2, 0.1
		)
	move_and_slide()


func _unhandled_input(event):
	#if event is InputEventMouseButton and event.pressed:
	if event.is_action_pressed("move_input"):
		var target_pos = get_global_mouse_position()
		$NavigationAgent2D.target_position = target_pos


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity.normalized() * speed
	#move_and_slide()



#--------------- DEPRECATED across this line ------------------
func __physics_process(delta):
	handle_rotation(delta)
	handle_thrust(delta)
	apply_friction(delta)

	velocity = velocity.limit_length(MAX_SPEED * speed_up_multi)
	set_velocity(velocity)
	move_and_slide()
	$ThrusterParticles.initial_velocity_max = 50
	$ThrusterParticles.initial_velocity_min = 20
	
	if curr_anim == anim:
		return
		
	$AnimatedSprite2D.play(curr_anim)
	anim = curr_anim
	
func handle_rotation(delta):
	var rotate_dir := 0

	if Input.is_action_pressed("left"):
		rotate_dir -= 1

	if Input.is_action_pressed("right"):
		rotate_dir += 1
		
	if aiming:
		rotation_multi = 0.3

	rotation += rotate_dir * ROTATION_SPEED * rotation_multi * delta

	if rotate_dir < 0:
		curr_anim = "move-left"
	elif rotate_dir > 0:
		curr_anim = "move-right"
	else:
		curr_anim = "idle"

func handle_thrust(delta):
	if Input.is_action_pressed("boost") and boost_available:
		PlayerStats.booster_fuel -= PlayerStats.boost_fuel_persec * delta

		target_multi = PlayerStats.boost_speed_multi
		rotation_multi = 0.2

		if PlayerStats.booster_fuel <= 0:
			boost_available = false
	else:
		target_multi = 1
		rotation_multi = 1

		if PlayerStats.get_booster_fuel() < PlayerStats.max_boost_fuel:
			PlayerStats.booster_fuel += PlayerStats.boost_fuel_regen * delta
			PlayerStats.booster_fuel = clamp(PlayerStats.booster_fuel, 0, PlayerStats.max_boost_fuel)

		if PlayerStats.booster_fuel >= PlayerStats.max_boost_fuel * 0.3:
			boost_available = true

	
	speed_up_multi = move_toward(speed_up_multi, target_multi, 6 * delta)
	
	if Input.is_action_pressed("move"):
		var forward := Vector2.UP.rotated(rotation)
		velocity += forward * ACCELERATION * speed_up_multi * delta

func apply_friction(delta):
	if not Input.is_action_pressed("move"):
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * speed_up_multi * delta)

func apply_aiming_rotation(status):
	aiming = status

func receive_damage(damage_data):
	var health = get_node_or_null("Health")
	print(health)
	if health:
		health.apply_damage(damage_data)

func die():
	SignalBus.emit_signal("game_over", self)
