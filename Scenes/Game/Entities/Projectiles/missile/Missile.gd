extends Area2D

var rot := 0.0
var forward = Vector2.UP
var _owner = null
var team

const MAX_SPEED = 600
const DAMAGE = 300
var damage_data = DamageData.new()
var elapsed = 0.0
var speed = 0

func _setup(gun):
	_owner = gun.get_parent()
	
	global_position = gun.global_position
	rotation = gun.global_rotation
	team = _owner.team
	
	damage_data.source = _owner
	damage_data.amount = DAMAGE
	damage_data.source_team = team


func _physics_process(delta):
	elapsed += delta
	speed = move_toward(speed, MAX_SPEED, 5 * elapsed)
	
	position += forward.rotated(rotation) * speed * delta
	if elapsed >= 6:
		queue_free()

func _on_Missile_area_entered(area):
	if not area.is_in_group('hurtbox'):
		return
	
	if area.get_parent() == _owner:
		return

	SignalBus.emit_signal('explosion' ,global_position , 200, damage_data)
	queue_free()
