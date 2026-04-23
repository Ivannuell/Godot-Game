extends Area2D
class_name Projectile

var team
var _owner

func on_hit(target):
	push_error("on_hit must be implemented")
