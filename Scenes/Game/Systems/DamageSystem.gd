extends Node

const DAMAGE_AREA = preload("res://Scenes/Game/Entities/Components/Damage_area/Damage_area.tscn")
const AREA_EXPLOSION_FX = preload("res://Scenes/Game/Entities/Components/FX/Area_Explosion/Area_ExplosionFX.tscn")
const PROJECTILE_EXPLOSTION_FX = preload("res://Scenes/Game/Entities/Components/FX/Projectile_Explosion/Projectile_Explosion.tscn")

func _ready():
	SignalBus.connect("entity_damaged", self, "_on_entity_damaged")
	SignalBus.connect("explosion", self, "on_explosion")
	SignalBus.connect("hit", self, "on_hit")


func _on_entity_damaged(entity, amount, source):
	var fx = PROJECTILE_EXPLOSTION_FX.instance()
	fx.global_position = source.global_position
	add_child(fx)



func on_explosion(pos, radius, damage_data):
	var explosion = DAMAGE_AREA.instance()
	var explosionFX = AREA_EXPLOSION_FX.instance()
	
	explosion.global_position = pos
	explosionFX.global_position = pos
	explosion.get_node("Shape").shape.radius = radius
	explosion.damage_data = damage_data
	
	yield(get_tree(), "physics_frame")
	add_child(explosion)
	add_child(explosionFX)


func on_hit(hurtbox, damage_data):
	hurtbox.receive_damage(damage_data)
	
	
func random_point_in_circle(center: Vector2, radius: float) -> Vector2:
	var u := randf()
	var theta := randf() * TAU
	var r := radius * sqrt(u)
	
	return center + Vector2(cos(theta), sin(theta)) * r
