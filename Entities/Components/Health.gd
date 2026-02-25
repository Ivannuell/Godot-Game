extends Node2D

export var max_hp := 100 setget set_max_hp, get_max_hp
var current_health := max_hp

func _ready():
	current_health = max_hp
	
func set_max_hp(value):
	max_hp = value
	
func get_max_hp():
	return max_hp

func apply_damage(damage: DamageData):
	var final_damage = calculate_damage(damage)
	current_health -= final_damage
	
#	print(damage.source)

	SignalBus.emit_signal("entity_damaged", get_parent(), final_damage, damage.source)

	if current_health <= 0:
		current_health = 0
		SignalBus.emit_signal("entity_died", get_parent())

func calculate_damage(damage: DamageData) -> float:
	var result = damage.amount
	
	return max(result, 0)
