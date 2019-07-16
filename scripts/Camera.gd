extends Camera2D

func _ready():
	set_process(true)

func _process(delta):
	position = get_tree().get_root().get_node('Root/Player/KinematicBody2D').global_position
#	position = get_tree().get_root().get_node('Root/Projectile').global_position
