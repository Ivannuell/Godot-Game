extends Node

const DAMAGE_AREA = preload("res://Scenes/Game/Entities/Components/Damage_area/Damage_area.tscn")
const EXPLOSION_FX = preload("res://Scenes/Game/Entities/Components/FX/ExplosionFX.tscn")


func _ready():
	SignalBus.connect("entity_damaged", self, "_on_entity_damaged")
	SignalBus.connect("explosion", self, "on_explosion")
	SignalBus.connect("hit", self, "on_hit")


func _on_entity_damaged(entity, amount, source):
	pass


func on_explosion(pos, radius, damage_data):
	var explosion = DAMAGE_AREA.instance()
	var explosionFX = EXPLOSION_FX.instance()
	
	explosion.global_position = pos
	explosionFX.global_position = pos
	explosion.get_node("Shape").shape.radius = radius
	explosion.damage_data = damage_data
	
	yield(get_tree(), "physics_frame")
	add_child(explosion)
	add_child(explosionFX)


func on_hit(hurtbox, damage_data):
	hurtbox.receive_damage(damage_data)
