extends Area2D

var target = null
var cargo = 0

func _ready():
	pass
	
func _physics_process(delta):
	if target == null or not is_instance_valid(target):
		return
		
	global_position = global_position.move_toward(target.global_position, 200 * delta)
	
	if global_position.distance_to(target.global_position) < 30:
		SignalBus.emit_signal("cargo_collected", self, target)

func _on_SpawnedCargo_body_entered(body):
	var cargo = body.get_node_or_null('Cargo')
	if cargo == null:
		return
		
	target = body


func _on_SpawnedCargo_body_exited(body):
	if body == target:
		target = null
