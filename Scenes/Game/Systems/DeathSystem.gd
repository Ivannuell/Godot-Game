extends Node

const SPAWNED_CARGO = preload("res://Scenes/Game/Entities/Components/Cargo/SpawnedCargo.tscn")

func _ready():
	SignalBus.connect("entity_died", Callable(self, "_on_entity_died"))
	SignalBus.connect("cargo_spawned", Callable(self, "_on_cargo_spawned"))
	SignalBus.connect("cargo_collected", Callable(self, "_on_cargo_collected"))

func _on_entity_died(entity):
	entity.die()
	
func _on_cargo_spawned(cargo):
	var loot = SPAWNED_CARGO.instantiate()
	loot.global_position = cargo.global_position
	loot.cargo = cargo.current
	
	$"../../Entities".call_deferred("add_child", loot)
	
func _on_cargo_collected(cargo, target):
	target.get_node("Cargo").current += cargo.cargo
	cargo.queue_free()
	
