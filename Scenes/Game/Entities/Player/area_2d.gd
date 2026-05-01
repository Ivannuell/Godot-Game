extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_entered(area: Area2D) -> void:
	if area is HurtBox and area.get_parent() is Spaceship:
		get_parent().add_enemy_in_range(area.get_parent())


func _on_area_exited(area: Area2D) -> void:
	get_parent().remove_enemy_in_range(area.get_parent())
