extends Node

func _ready():
	SignalBus.connect("entity_died", self, "_on_entity_died")

func _on_entity_died(entity):
	entity.queue_free()
