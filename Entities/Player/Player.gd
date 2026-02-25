extends KinematicBody2D
class_name Player

var team = 'Allies'

const MAX_SPEED := 200.0
const ACCELERATION := 400.0
const FRICTION := 200.0
const ROTATION_SPEED := 2  # radians per second

var velocity = Vector2.ZERO

func _ready():
	add_to_group(team)

func _physics_process(delta):

	handle_rotation(delta)
	handle_thrust(delta)
	apply_friction(delta)

	velocity = velocity.limit_length(MAX_SPEED)
	move_and_slide(velocity)

	
func handle_rotation(delta):
	var rotate_dir := 0

	if Input.is_action_pressed("left"):
		rotate_dir -= 1

	if Input.is_action_pressed("right"):
		rotate_dir += 1

	rotation += rotate_dir * ROTATION_SPEED * delta

	if rotate_dir < 0:
		$AnimatedSprite.play("move-left")
	elif rotate_dir > 0:
		$AnimatedSprite.play("move-right")
	else:
		$AnimatedSprite.play("idle")

	
func handle_thrust(delta):
	if Input.is_action_pressed("move"):
		var forward := Vector2.UP.rotated(rotation)
		velocity += forward * ACCELERATION * delta


func apply_friction(delta):
	if not Input.is_action_pressed("move"):
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

