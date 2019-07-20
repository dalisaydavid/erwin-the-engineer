extends Node2D

export(String, FILE, '*tscn') var next_scene_path
export (NodePath) var root_node_path

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play('Pulse')
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	if body.get_parent().get_name() == 'Player':
		if next_scene_path:
			get_tree().change_scene(next_scene_path)