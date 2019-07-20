extends Position2D

export(String, FILE, '*tscn') var exit_scene_path
export (String, FILE, '*tscn') var next_scene_path

func _ready():
	get_tree().get_root().get_node('Root').connect('scene_finished', self, 'spawn_position')

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func spawn_position():
	var exit_node = load(exit_scene_path).instance()
	exit_node.next_scene_path = next_scene_path
	exit_node.global_position = self.global_position
	get_tree().get_root().get_node('Root').add_child(exit_node)
	queue_free()