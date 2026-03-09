extends Node
class_name Game_Stat

enum TEAM {
	PLAYER,
	ENEMY,
	FARM
}

signal player_mineral_changed
signal enemy_mineral_changed

var player_minerals := 0 setget set_player_minerals
var enemy_minerals := 0 setget set_enemy_minerals

func set_player_minerals(value):
	player_minerals = value
	emit_signal("player_mineral_changed")
func set_enemy_minerals(value):
	enemy_minerals = value
	emit_signal("enemy_mineral_changed")

func _ready():
	SignalBus.connect("minerals_changed", self, "on_minerals_changed")
	
func on_minerals_changed(team, amount):
	if team == TEAM.PLAYER:
		self.player_minerals = amount
	else:
		self.enemy_minerals = amount
