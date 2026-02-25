extends Node

func _ready():
	SignalBus.connect("entity_damaged", self, "_on_entity_damaged")

func _on_entity_damaged(entity, amount, source):
	
	if not is_instance_valid(entity) or not is_instance_valid(source):
		return
		
#	print(entity.name, " took ", amount, " damage from ", source.name)
