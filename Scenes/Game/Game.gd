extends Node2D

onready var shop = $UI/Shop
onready var playerBase = $Entities/Allies/Base
onready var enemyBase = $Entities/Enemies/Base
onready var stateMachine = $GameStateMachine

onready var enemyAI = $EnemyAI


func _ready():
	shop.connect("manufacture_requested", self, "on_manufacture_request")
	enemyAI.connect("manufacture_requested", self, "on_enemy_manufacture_request")
		
func _unhandled_input(event):
	if event.is_action_pressed("pause_game"):
		stateMachine.change_state(
			stateMachine.PAUSE_STATE.new()
		)
	
	
	if event.is_action_pressed("ui_debug_stop_enemies"):
		for enemy in get_tree().get_nodes_in_group('Enemies'):
			enemy.toggle_moving()
		
	if event.is_action_pressed("spawn"):
		shop.visible = !shop.visible


var Spaceships = {
	'ATTACK': 1000,
	'MINER': 1500
}


func on_manufacture_request(type):
	if playerBase.minerals >= Spaceships[type]:
		playerBase.minerals -= Spaceships[type]
		SpaceshipFactory.spawn(playerBase, type)
		
func on_enemy_manufacture_request(type):
	if enemyBase.minerals >= Spaceships[type]:
		enemyBase.minerals -= Spaceships[type]
		SpaceshipFactory.spawn(enemyBase, type)

