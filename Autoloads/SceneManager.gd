extends Node

var container = null

func _ready():
	container = get_tree().get_root().get_node("Main/SceneContainer")

func change_scene(path):
	if container.get_child_count() > 0:
		container.get_child(0).queue_free()

	var scene = load(path).instance()
	container.add_child(scene)
