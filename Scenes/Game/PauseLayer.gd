extends CanvasLayer

onready var stateMachine = $"../GameStateMachine"

func _ready():
	pass


func _on_Button_pressed():
	stateMachine.change_state(
		stateMachine.RUNNING_STATE.new()
	)
