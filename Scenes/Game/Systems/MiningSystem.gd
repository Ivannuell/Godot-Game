extends Node


func _ready():
	SignalBus.connect("start_mining", Callable(self, "on_started_mining"))
	

func on_started_mining(mining_tool):
	pass
