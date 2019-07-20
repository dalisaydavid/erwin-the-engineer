extends CanvasLayer

export var scene_name = 'Scene Name'

# Called when the node enters the scene tree for the first time.
func _ready():
	$MarginContainer/Label.text = scene_name

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
