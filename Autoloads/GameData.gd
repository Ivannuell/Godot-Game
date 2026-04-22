extends Node
class_name Game_Stat

enum TEAM {
	PLAYER,
	ENEMY,
	FARM
}

signal player_mineral_changed
signal enemy_mineral_changed

var game_time = 0.0
var update_time = 0.0

var player_minerals := 0: set = set_player_minerals
var enemy_minerals := 0: set = set_enemy_minerals

var enemy_miners := 0
var enemy_attackers := 0


func set_player_minerals(value):
	player_minerals = value
	emit_signal("player_mineral_changed")
func set_enemy_minerals(value):
	enemy_minerals = value
	emit_signal("enemy_mineral_changed")


func _ready():
	reset()
	SignalBus.connect("minerals_changed", Callable(self, "on_minerals_changed"))


func on_minerals_changed(team, amount):
	if team == TEAM.PLAYER:
		self.player_minerals = amount
	else:
		self.enemy_minerals = amount


func _process(delta):
	update_time += delta
	
	if update_time >= 1:
		update_stat()


func reset():
	player_minerals = 0
	enemy_minerals = 0


func update_stat():
	count_enemy_miners()
	count_enemy_attackers()


func count_enemy_miners():
	enemy_miners = get_tree().get_nodes_in_group("enemy_miners").size()
	
func count_enemy_attackers():
	enemy_attackers = get_tree().get_nodes_in_group("enemy_attackers").size()
