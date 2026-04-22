extends Area2D
var team
var _owner

var speed = 500
var rot: float
var direction: Vector2
const MAX_TRAVEL_TIME = 2
var elapsed = 0.0

const DAMAGE = 10
var damage_data = DamageData.new()

func _setup(gun):
	_owner = gun.get_parent()
	
	global_position = gun.global_position
	rotation = gun.rotation - PI/2
	team = _owner.team
	
	damage_data.source = self
	damage_data.amount = DAMAGE
	damage_data.source_team = team
	damage_data.owner = _owner



func _physics_process(delta):
	position += Vector2.UP.rotated(rotation) * speed * delta
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
	
	SignalBus.emit_signal("entity_damaged",area, damage_data)
	SignalBus.emit_signal("hit" ,self)
	queue_free()
