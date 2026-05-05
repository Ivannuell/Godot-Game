extends Node

var enemy_inRange: Array = []
var active_Enemy

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
		var selected_index = char(event.unicode)
		if selected_index.is_valid_int():
			for i in enemy_inRange:
				if i.index == int(selected_index):
					on_activate_enemy(i)
					active_Enemy = i

func on_enemy_enter(enemy: Spaceship):
	enemy_inRange.append(enemy)
	inititalize_enemy_list()


func on_enemy_exit(enemy: Spaceship):
	enemy_inRange.erase(enemy)
	enemy.deactivate()
		
	inititalize_enemy_list()


func inititalize_enemy_list():
	var index = 1
	for i in enemy_inRange:
		i.update_index(index)
		if index == 1:
			i.activate()
		index += 1
	
	index = 0


func on_activate_enemy(enemy: Spaceship):
	for i in enemy_inRange:
		on_deactivate_enemy(i)
	
	enemy.activate()


func on_deactivate_enemy(enemy: Spaceship):
	enemy.deactivate()
