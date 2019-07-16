extends Node2D

export var is_friendly_dimension_on = 0
export(String, FILE, '*tscn') var next_scene_path
signal scene_finished
var is_scene_finished = false
export var scene_message = 'Scene Finished! (Press 0 to continue)'
# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.connect('dimension_changed', self, '_on_Player_dimension_changed')
		
	self.connect('scene_finished', self, 'set_scene_finished')
	set_process_input(true)
	set_process(true)

func _process(delta):
	check_scene_finished()
	
func _input(event):
	if event.is_action_pressed('change_scene'):
		if next_scene_path and is_scene_finished:
			get_tree().change_scene(next_scene_path)

func set_scene_finished():
	is_scene_finished = true

func check_scene_finished():
	var npcs = get_tree().get_nodes_in_group('npc')
	
	if len(npcs) == 0:
		emit_signal('scene_finished')
		is_scene_finished = true
		

func _on_Player_dimension_changed():
	is_friendly_dimension_on = not is_friendly_dimension_on
	
