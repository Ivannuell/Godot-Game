extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body is Spaceship:
		SignalBus.emit_signal("enter_enemy", body)
		body.show_word()


func _on_body_exited(body: Node2D) -> void:
	if body is Spaceship:
		SignalBus.emit_signal("exit_enemy", body)
		body.hide_word()
