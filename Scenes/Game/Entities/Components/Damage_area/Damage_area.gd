extends Area2D

export var lifetime: float = 0.1

var damage_data = null

func _ready():
	add_to_group("damage_area")
	
	yield(get_tree(), "physics_frame")
	_apply_damage()
	
	yield(get_tree().create_timer(lifetime), "timeout")
	queue_free()


func _apply_damage():
	for area in get_overlapping_areas():
		if area.is_in_group("hurtbox"):
			area.receive_damage(damage_data)
			
			if area.get_parent().is_in_group("asteroids"):
				area.get_parent().destroy()
