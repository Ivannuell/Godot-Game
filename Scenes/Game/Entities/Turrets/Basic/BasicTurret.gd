extends Node2D

enum Team {
	PLAYER,
	ENEMY,
	NEUTRAL
}

export (Team) var team = Team.PLAYER

func _ready():
	add_to_group(str(team))
	$AutoGun.detection_radius = 400
func receive_damage(damage_data):
	var health = get_node_or_null("Health")
	if health:
		health.apply_damage(damage_data)

func die():
	queue_free()
