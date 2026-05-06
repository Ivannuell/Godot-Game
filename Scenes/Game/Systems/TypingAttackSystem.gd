extends Node

var enemy_inRange: Array = []
var active_Enemy: Spaceship

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.connect("activate_enemy", on_activate_enemy)
	SignalBus.connect("deactivate_enemy", on_deactivate_enemy)
	SignalBus.connect("enter_enemy", on_enemy_enter)
	SignalBus.connect("exit_enemy", on_enemy_exit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(event: InputEvent) -> void:	
	if event is InputEventKey and event.pressed and not event.echo:
		var input = char(event.unicode)
		
		if event.unicode == 0:
			return
		
		if input.is_valid_int():
			var target_index = int(input)
			if target_index >= 1 and target_index <= 9:
				for i in enemy_inRange:
					if i.index == target_index:
						SignalBus.emit_signal("activate_enemy", i)
						active_Enemy = i
						break
					
		if not active_Enemy:
			return
			
		if active_Enemy.check_input(input):
			if active_Enemy.is_word_complete():
				active_Enemy.on_word_completed()
				active_Enemy = null
				call_deferred("inititalize_enemy_list")

func inititalize_enemy_list():
	if enemy_inRange.is_empty():
		SignalBus.emit_signal("no_enemy")
		active_Enemy = null
		return
	
	var index = 1
	for i in enemy_inRange:
		i.update_index(index)
		index += 1

	if active_Enemy == null and enemy_inRange.size() > 0:
		SignalBus.emit_signal("activate_enemy", enemy_inRange[0])
		
	

func on_enemy_enter(enemy: Spaceship):
	enemy_inRange.append(enemy)
	inititalize_enemy_list()

func on_enemy_exit(enemy: Spaceship):
	enemy_inRange.erase(enemy)
	enemy.deactivate()

	if enemy_inRange.is_empty():
		SignalBus.emit_signal("no_enemy")
		active_Enemy = null
	else:
		active_Enemy = null
		inititalize_enemy_list()

func on_activate_enemy(enemy: Spaceship):
	for i in enemy_inRange:
		i.deactivate()
	
	enemy.activate()
	active_Enemy = enemy

func on_deactivate_enemy(enemy: Spaceship):
	enemy.deactivate()
