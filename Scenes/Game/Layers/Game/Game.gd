extends Node2D

@onready var shop = $UI/Shop
@onready var playerBase = $Entities/Allies/Base
@onready var enemyBase = $Entities/Enemies/Base
@onready var stateMachine = $GameStateMachine

@onready var enemyAI = $Systems/EnemyAI


func _ready():
	shop.connect("manufacture_requested", Callable(self, "on_manufacture_request"))
	enemyAI.connect("manufacture_requested", Callable(self, "on_enemy_manufacture_request"))
	SignalBus.connect("game_over", Callable(self, "_on_game_over"))

func _on_game_over(base):
	stateMachine.change_state(
		stateMachine.GAMEOVER_STATE.new()
	)


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


func on_manufacture_request(type):
	if not is_instance_valid(playerBase):
		return
	
	var price = SpaceshipFactory.Spaceships[type]
	
	if playerBase.minerals >= price:
		playerBase.minerals -= price
		SpaceshipFactory.spawn(playerBase, type)
	
func on_enemy_manufacture_request(type):
	if not is_instance_valid(enemyBase):
		return
	
	var price = SpaceshipFactory.Spaceships[type]
	
	if enemyBase.minerals >= price:
		enemyBase.minerals -= price
		SpaceshipFactory.spawn(enemyBase, type)
