extends Node2D

export(String, FILE, '*tscn') var next_scene_path
var checked_if_dead = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$BodyAnimationPlayer.play('Move')
	$GunAnimationPlayer.play('Shoot')
	
	set_process_input(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.game_over_from_death and not checked_if_dead:
		$CanvasLayer/VBoxContainer/Label2.text = 'You died! Press ENTER to continue.\n\n' + $CanvasLayer/VBoxContainer/Label2.text
		checked_if_dead = true

func _input(event):
	if event.is_action_pressed('ui_accept'):
		get_tree().change_scene(next_scene_path)
