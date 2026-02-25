extends Node2D
		
func _unhandled_input(event):
	if event.is_action_pressed("ui_debug_stop_enemies"):
		for enemy in get_tree().get_nodes_in_group('Enemies'):
			enemy.toggle_moving()
