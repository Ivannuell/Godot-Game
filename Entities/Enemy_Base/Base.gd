extends Node2D

onready var enemy_container_node = get_parent().get_node("Enemies")

const GUN_SCENE = preload("res://Entities/Weapons/AutoGun/AutoGun.tscn")
const HEALTH_SCENE = preload("res://Entities/Components/Health.tscn")

export (PackedScene) var enemy
export (String) var team

var minerals = 0

func spawn_enemy():
	var ent = enemy.instance()
	ent.add_child(GUN_SCENE.instance())
	ent.add_child(HEALTH_SCENE.instance())
	
	ent.global_position = global_position
	enemy_container_node.add_child(ent)


func _on_SpawnTimer_timeout():
#	spawn_enemy()
	print(minerals)
	pass



func _on_Area2D_body_entered(body):
	if not body.team == team:
		return
		
	print(body)
		
	var cargo = body.get_node_or_null('Cargo')
	
	if cargo:
		minerals += cargo.deposit_all()
