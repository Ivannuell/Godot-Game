extends CanvasLayer

export(NodePath) var camera_path

onready var camera = get_node(camera_path)
onready var shader_mat = $ColorRect.material


func _process(delta):
	if shader_mat == null:
		return

	if camera == null:
		return

	shader_mat.set_shader_param("camera_pos", camera.global_position)
	shader_mat.set_shader_param("zoom", camera.zoom.x)
