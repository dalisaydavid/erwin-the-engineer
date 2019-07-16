extends CanvasLayer

export (NodePath) var player_path
var player
var root
export var label_prefix = 'Worm holes: '

func _ready():
	player = get_node(player_path)
	player.connect('ammo_changed', self, 'display_ammo')
	
	root = get_tree().get_root().get_node('Root')
	root.connect('scene_finished', self, 'display_scene_finished')

func display_scene_finished():
	$MarginContainer/VBoxContainer/HBoxContainer2/Label.text = root.scene_message
	
func display_ammo():
	$MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer/MarginContainer2/TextureRect1.set_visible(player.ammo >= 1)
	$MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer/MarginContainer3/TextureRect2.set_visible(player.ammo >= 2)
