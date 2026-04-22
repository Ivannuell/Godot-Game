extends Area2D


func _ready():
	pass


func _process(delta):
	$Sprite2D.material.set_shader_parameter("time", Time.get_ticks_msec() / 1000.0)
