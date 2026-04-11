extends Node2D
class_name Base

const GUN_SCENE = preload("res://Scenes/Game/Entities/Weapons/AutoGun/AutoGun.tscn")
const HEALTH_SCENE = preload("res://Scenes/Game/Entities/Components/Health/Health.tscn")

enum Team {
	PLAYER,
	ENEMY,
	NEUTRAL
}

export (Team) var team = Team.PLAYER
export (Texture) var base 

var minerals = 0 setget set_minerals, get_minerals
var time = 0.0

func _ready():
	add_to_group(str(team))
	
	if !base:
		$Sprite.texture = load("res://Scenes/Game/Entities/Base/SpaceStation.png")
	else:
		$Sprite.texture = base
		
func _physics_process(delta):
	time += delta
	
	if time >= 1:
		self.minerals += GameEconomy.passiveIncome
		time = 0.0


func set_minerals(value):
	minerals = value
	SignalBus.emit_signal("minerals_changed", team, minerals)
func get_minerals():
	return minerals


func deduct_minerals(value):
	self.minerals -= value
	SignalBus.emit_signal("minerals_changed", team, minerals)


func receive_damage(damage_data):
	var health = get_node_or_null("Health")
	if health:
		health.apply_damage(damage_data)


func die():
	SignalBus.emit_signal('game_over', self)
	queue_free()

