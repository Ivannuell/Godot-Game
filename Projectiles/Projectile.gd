extends Area2D

var team
var _owner

var speed = 500
var rot: float
var direction: Vector2
const MAX_TRAVEL_TIME = 1
var elapsed = 0.0

const DAMAGE = 10

func _ready():
	rotation = rot
	direction = Vector2.UP.rotated(rotation)

var damage_data = DamageData.new()

func _setup(gun):
	_owner = gun.get_parent()
	
	global_position = gun.global_position
	rot = gun.rotation - PI/2
	team = _owner.team
	damage_data.source = _owner
	damage_data.amount = DAMAGE


func _process(delta):
	position += direction * speed * delta
	elapsed += delta
	if elapsed >= MAX_TRAVEL_TIME:
		queue_free()


func _on_Area2D_area_entered(area):
	var body = area.get_parent()
	
	if body == _owner:
		return
	
	if body.team == team:
		return


	var health = body.get_node_or_null("Health")
	if health:
		health.apply_damage(damage_data)
	queue_free()
