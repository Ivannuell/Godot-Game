extends Camera2D

var target_zoom = Vector2()
var zoom_speed = 8.0
var zoom_step = 0.1
var min_zoom = 0.5
var max_zoom = 10.0

func _ready():
	target_zoom = zoom

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_WHEEL_UP:
			target_zoom -= Vector2.ONE * zoom_step
		elif event.button_index == BUTTON_WHEEL_DOWN:
			target_zoom += Vector2.ONE * zoom_step

		target_zoom.x = clamp(target_zoom.x, min_zoom, max_zoom)
		target_zoom.y = clamp(target_zoom.y, min_zoom, max_zoom)

func _process(delta):
	zoom = zoom.linear_interpolate(target_zoom, zoom_speed * delta)
