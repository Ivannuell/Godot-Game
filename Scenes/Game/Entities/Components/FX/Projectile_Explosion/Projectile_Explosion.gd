extends AnimatedSprite2D


func _ready():
	pass


func _on_AnimatedSprite_animation_finished():
	queue_free()
