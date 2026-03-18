extends Node

var decision_time = 0.0

onready var enemy_base = $"../Entities/Enemies/Base"

signal manufacture_requested(type)


func _ready():
	pass
	
func _process(delta):
	decision_time += delta
	
	if decision_time >= 2:
		decision_time = 0
		evaluate()
		

func evaluate():
	if GameData.enemy_minerals < 5000:
		emit_signal("manufacture_requested", "MINER")
	
	
	if GameData.enemy_miners < 6:
		if GameData.enemy_minerals > 2000:
			emit_signal("manufacture_requested", "MINER")

	if GameData.enemy_attackers < 5:
		if GameData.enemy_minerals > 2000:
			emit_signal("manufacture_requested", "ATTACK")
