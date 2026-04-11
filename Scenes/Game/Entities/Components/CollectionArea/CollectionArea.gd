extends Area2D
class_name CollectionArea

func _ready():
	pass


func _on_Area2D_body_entered(body):
	var _owner = get_parent()
	
	if not body.team == _owner.team:
		return
	
	var cargo = body.get_node_or_null('Cargo')
	
	if cargo:
		_owner.minerals += cargo.deposit_all()
