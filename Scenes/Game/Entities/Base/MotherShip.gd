extends Base


export (PackedScene) var EnemyBase


var center = Vector2.ZERO

func _ready():
	center = EnemyBase.global_position



func _physics_process(delta):
	var dx = sin(rotation)
	var dy = cos(rotation)
	
	position = center + Vector2(dx, dy)
	
