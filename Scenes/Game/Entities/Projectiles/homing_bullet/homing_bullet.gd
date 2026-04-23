extends Projectile
class_name Homing_bullet

var speed = 500
var rot: float
var direction: Vector2
const MAX_TRAVEL_TIME = 1
var elapsed = 0.0
var target = null

const DAMAGE = 20
var damage_data = DamageData.new()

func _setup(gun):
	_owner = gun.get_parent()
	
	global_position = gun.global_position
	rotation = gun.rotation - PI/2
	team = _owner.team
	target = gun.target
	
	damage_data.source = self
	damage_data.owner = _owner
	damage_data.amount = DAMAGE
	damage_data.source_team = team



func _physics_process(delta):
	if target == null or not is_instance_valid(target):
		global_position = global_position.move_toward(Vector2.UP.rotated(rotation), speed * delta)
	else:
		global_position = global_position.move_toward(target.global_position, speed * delta)
		rotation = global_position.angle_to_point(target.global_position) - PI/2
		
	elapsed += delta
	if elapsed >= MAX_TRAVEL_TIME:
		queue_free()



func _on_Area2D_area_entered(area):
	if not area.is_in_group('hurtbox'):
		return
		
	if area.get_parent() == _owner:
		return
		
	if area.get_parent().team == team:
		return
	
	SignalBus.emit_signal("entity_damaged" ,area, damage_data)
	on_hit(area)
	
func on_hit(target):
	SignalBus.emit_signal("hit" ,self)
	queue_free()
