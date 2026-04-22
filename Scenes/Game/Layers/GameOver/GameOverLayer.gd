extends CanvasLayer


func _ready():
	pass


func _on_Button_pressed():
	AppStateMachine.change_state(
		AppStateMachine.GameplayState.new()
	)



func _on_Button2_pressed():
	AppStateMachine.change_state(
		AppStateMachine.MainMenuState.new()
	)
