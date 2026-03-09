extends Node2D
var lifetime = 1.0

func _ready():
	$CPUParticles2D.emitting = true
	$CPUParticles2D.lifetime = lifetime
	$CPUParticles2D.emission_sphere_radius = 100
	
	yield(get_tree().create_timer(lifetime), "timeout")
	queue_free()
