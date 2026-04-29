extends Node

const DAMAGE_AREA = preload("res://Scenes/Game/Entities/Components/Damage_area/Damage_area.tscn")
const AREA_EXPLOSION_FX = preload("res://Scenes/Game/Entities/Components/FX/Area_Explosion/Area_ExplosionFX.tscn")
const PROJECTILE_EXPLOSTION_FX = preload("res://Scenes/Game/Entities/Components/FX/Projectile_Explosion/Projectile_Explosion.tscn")

func _ready():
	SignalBus.connect("entity_damaged", _on_entity_damaged)
	SignalBus.connect("explosion", _on_explosion)
	SignalBus.connect("hit", _on_hit)


func _on_entity_damaged(hurtbox, damage_data):
	hurtbox.receive_damage(damage_data)


func _on_explosion(pos, radius, damage_data):
	var explosion = DAMAGE_AREA.instantiate()
	explosion.global_position = pos
	
	explosion.get_node("Shape3D").shape.radius = radius
	explosion.damage_data = damage_data
	
	call_deferred("add_child", explosion)
	_on_explosion_FX(pos)


func _on_explosion_FX(pos):
	var explosionFX = AREA_EXPLOSION_FX.instantiate()
	explosionFX.global_position = pos
	
	call_deferred("add_child", explosionFX)

#TODO: Maybe fixed the naming and make it explicit that it only handle's FX for projectile hit
func _on_hit(source):
	#Spawns a hit animation
	var fx = PROJECTILE_EXPLOSTION_FX.instantiate()
	fx.global_position = source.global_position
	add_child(fx)


func random_point_in_circle(center: Vector2, radius: float) -> Vector2:
	var u := randf()
	var theta := randf() * TAU
	var r := radius * sqrt(u)
	
	return center + Vector2(cos(theta), sin(theta)) * r
