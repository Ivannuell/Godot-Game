extends Node2D

var source
var target
var active = false

func start_beam(from, to):
	source = from
	target = to
	active = true
	show()

func stop_beam():
	active = false
	hide()

func _process(delta):
	if not active:
		return

	if not is_instance_valid(target):
		stop_beam()
		return

	global_position = source.global_position

	var end_point = to_local(target.global_position)
	$Line2D.points = [Vector2.ZERO, end_point]
