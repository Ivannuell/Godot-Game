extends Area2D

export var detection_radius := 150.0 setget set_detection_radius
export (PackedScene) var projectile

var enemies_in_range = []
onready var team = get_parent().team

func _ready():
	add_to_group('guns')
	$"%Gun_Range".shape = $"%Gun_Range".shape.duplicate()
	set_detection_radius(detection_radius)
	$CooldownTimer.start()

func get_opposite_team() -> String:
	return "Allies" if team == "Enemies" else "Enemies"

func set_detection_radius(value):
	detection_radius = value
	$"%Gun_Range".shape.radius = value

# Enemy enters range
func _on_AutoGun_area_entered(area):
	var enemy = area.get_parent()
	if enemy.is_in_group(get_opposite_team()) and !(enemy in enemies_in_range):
		enemies_in_range.append(enemy)
		if enemy.is_connected("tree_exited", self, "_on_enemy_exited"):
			return
			
		enemy.connect("tree_exited", self, "_on_enemy_exited", [enemy])


# Enemy exits range or dies
func _on_AutoGun_area_exited(area):
	var enemy = area.get_parent()
	_remove_enemy(enemy)
	

func _on_enemy_exited(enemy):
	_remove_enemy(enemy)

# Helper to remove enemy safely
func _remove_enemy(enemy):
	if enemy in enemies_in_range:
		enemies_in_range.erase(enemy)

# Pick closest enemy
func _get_closest_enemy():
	var closest = null
	var min_dist = INF
	for enemy in enemies_in_range:
		if not is_instance_valid(enemy):
			continue
		var dist = global_position.distance_to(enemy.global_position)
		if dist < min_dist:
			min_dist = dist
			closest = enemy
	return closest


func _on_CooldownTimer_timeout():
	var target = _get_closest_enemy()
	
	if get_parent() is Player:
		target = _get_prioritized_enemy()
	
	if not target:
		return
		
	rotation = global_position.angle_to_point(target.global_position)
	SignalBus.emit_signal("gun_shoot", self)
	$CooldownTimer.start()


func _get_prioritized_enemy():
	var best_enemy = null
	var best_score = -INF
	
	var cursor_dir = (get_global_mouse_position() - global_position).normalized()
	
	for enemy in enemies_in_range:
		if not is_instance_valid(enemy):
			continue
			
		var to_enemy = (enemy.global_position - global_position).normalized()
		
		# Cosine of angle between cursor_dir and enemy_dir
		# 1 = perfectly aligned, -1 = opposite direction
		var alignment = cursor_dir.dot(to_enemy)
		
		# Distance factor (optional: closer = better)
		var dist = global_position.distance_to(enemy.global_position)
		var distance_factor = 1.0 / (dist + 1)  # avoid divide by zero
		
		# Score = alignment + weighted distance
		var score = alignment * 0.7 + distance_factor * 0.3
		
		if score > best_score:
			best_score = score
			best_enemy = enemy
	return best_enemy
