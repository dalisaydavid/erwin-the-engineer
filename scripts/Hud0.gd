extends CanvasLayer

export (NodePath) var player_path
var player
var root
export var label_prefix = 'Worm holes: '

func _ready():
	player = get_node(player_path)
	player.connect('ammo_changed', self, 'display_ammo')
	player.connect('damaged', self, 'display_health')

	root = get_tree().get_root().get_node('Root')
	root.connect('scene_finished', self, 'display_scene_finished')
		
	display_ammo()
	
	set_process(true)

func _process(delta):
	if root:
		$MarginContainer/VBoxContainer/HBoxContainer2/TimerLabel.text = str(root.countdown_timer.time_left)

func display_scene_finished():
	$MarginContainer/VBoxContainer/HBoxContainer2/Label.text = root.scene_message
	
func display_ammo():
	$MarginContainer/VBoxContainer/HBoxContainer/TextureRect1.set_visible(player.ammo >= 1)
	$MarginContainer/VBoxContainer/HBoxContainer/TextureRect2.set_visible(player.ammo >= 2)
	$MarginContainer/VBoxContainer/HBoxContainer/TextureRect3.set_visible(player.ammo >= 3)
	$MarginContainer/VBoxContainer/HBoxContainer/TextureRect4.set_visible(player.ammo >= 4)
	$MarginContainer/VBoxContainer/HBoxContainer/TextureRect5.set_visible(player.ammo >= 5)
	
func display_health():
	$MarginContainer/VBoxContainer/HBoxContainer3/TextureRect.set_visible(player.health >= 1)
	$MarginContainer/VBoxContainer/HBoxContainer3/TextureRect2.set_visible(player.health >= 2)
	$MarginContainer/VBoxContainer/HBoxContainer3/TextureRect3.set_visible(player.health >= 3)
