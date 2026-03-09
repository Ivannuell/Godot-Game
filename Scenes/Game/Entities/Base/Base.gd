extends Node2D

const GUN_SCENE = preload("res://Scenes/Game/Entities/Weapons/AutoGun/AutoGun.tscn")
const HEALTH_SCENE = preload("res://Scenes/Game/Entities/Components/Health/Health.tscn")

enum Team {
	PLAYER,
	ENEMY,
	NEUTRAL
}

export (Team) var team = Team.PLAYER

var minerals = 0 setget set_minerals, get_minerals

func _ready():
	add_to_group(str(team))

func set_minerals(value):
	minerals = value
	SignalBus.emit_signal("minerals_changed", team, minerals)

func get_minerals():
	return minerals

func _on_Area2D_body_entered(body):
	if not body.team == team:
		return
	
	var cargo = body.get_node_or_null('Cargo')
	
	if cargo:
		self.minerals += cargo.deposit_all()

func receive_damage(damage_data):
	var health = get_node_or_null("Health")
	if health:
		health.apply_damage(damage_data)
		
func die():
	queue_free()
