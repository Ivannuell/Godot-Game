extends Base


@onready var EnemyBase = $"../../Enemies/Base"

var center = Vector2.ZERO
var orbit_angle = deg_to_rad(180)

func _ready():
	center = EnemyBase.global_position
	minerals = 10000

func _physics_process(delta):
	orbit_angle += delta * 0.01
	
	var dx = sin(orbit_angle)
	var dy = cos(orbit_angle)
	
	var ox = cos(orbit_angle) * 3000
	var oy = sin(orbit_angle) * 3000
	
	global_position.x = center.x + ox
	global_position.y = center.y + oy
	
	rotation = atan2(dx, dy)
	
	time += delta
	
	if time >= 1:
		self.minerals += GameEconomy.passiveIncome
		time = 0.0
	
