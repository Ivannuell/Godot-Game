extends CanvasLayer

onready var player_base = $"../../Entities/Allies/Base"

signal manufacture_requested(type)

func _ready():
	pass

func _on_Manufacture_pressed(type):
	emit_signal("manufacture_requested", type)
