extends Node

export (PackedScene) var enemy

signal spawnEnemy(enemy)


func _on_SpawnTimer_timeout():
	var ent = enemy.instance()
	var path = $Path2D/PathFollow2D
	
	path.unit_offset = randf()
	
	ent.position = path.position
#	ent.look_at()
	
	emit_signal("spawnEnemy", ent)
