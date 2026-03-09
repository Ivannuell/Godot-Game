extends Node
class_name SpaceShipFactory

const ATTACK = preload("res://Scenes/Game/Entities/Spaceships/Attacker/Attacker.tscn")
const MINER = preload("res://Scenes/Game/Entities/Spaceships/Miner/Miner.tscn")

const AUTO_GUN = preload("res://Scenes/Game/Entities/Weapons/AutoGun/AutoGun.tscn")


func spawn(base, type):
	var ent = null
	
	match type:
		'ATTACK':
			ent = ATTACK.instance()
			ent.add_child(AUTO_GUN.instance())
		'MINER':
			ent = MINER.instance()
			
	if ent == null:
		return
	
	var team = base.team
	
	ent.team = team
	ent.global_position = base.global_position
	
	var parent = base.get_parent()
	parent.add_child(ent)
