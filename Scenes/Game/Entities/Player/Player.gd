extends KinematicBody2D
class_name Player

enum Team {
	PLAYER,
	ENEMY,
	NEUTRAL
}

export (Team) var team = Team.PLAYER

const MAX_SPEED := 200.0
const ACCELERATION := 400.0
const FRICTION := 200.0
const ROTATION_SPEED := 2  # radians per second

var target_multi = 1.0
var speed_up_multi = 1.0
var rotation_multi = 1.0

var boost_available := true
onready var engine_particles = $ThrusterParticles

var velocity = Vector2.ZERO

func _ready():
	add_to_group(str(team))

func _physics_process(delta):
	handle_rotation(delta)
	handle_thrust(delta)
	apply_friction(delta)

	velocity = velocity.limit_length(MAX_SPEED * speed_up_multi)
	move_and_slide(velocity)
	$ThrusterParticles.initial_velocity = clamp(velocity.length(), 10, 50)

	
func handle_rotation(delta):
	var rotate_dir := 0

	if Input.is_action_pressed("left"):
		rotate_dir -= 1

	if Input.is_action_pressed("right"):
		rotate_dir += 1

	rotation += rotate_dir * ROTATION_SPEED * rotation_multi * delta

	if rotate_dir < 0:
		$AnimatedSprite.play("move-left")
	elif rotate_dir > 0:
		$AnimatedSprite.play("move-right")
	else:
		$AnimatedSprite.play("idle")

	
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

func receive_damage(damage_data):
	var health = get_node_or_null("Health")
	if health:
		health.apply_damage(damage_data)

func die():
	queue_free()
