extends Area2D

onready var team = get_parent().team

func _ready():
	add_to_group('hurtbox')

func receive_damage(damage_data):
	if damage_data.source == get_parent():
		return
	
	if damage_data.source_team == team:
		return
		
	get_parent().receive_damage(damage_data)
