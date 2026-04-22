extends Node2D
class_name Base

const GUN_SCENE = preload("res://Scenes/Game/Entities/Weapons/AutoGun/AutoGun.tscn")
const HEALTH_SCENE = preload("res://Scenes/Game/Entities/Components/Health/Health.tscn")

enum Team {
	PLAYER,
	ENEMY,
	NEUTRAL
}

@export var team: Team = Team.PLAYER
@export var base: Texture2D 

var minerals = 0: get = get_minerals, set = set_minerals
var time = 0.0

func _ready():
	add_to_group(str(team))
	
	if !base:
		$Sprite2D.texture = load("res://Scenes/Game/Entities/Base/SpaceStation.png")
	else:
		$Sprite2D.texture = base
		
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
