extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$RiseEffect.interpolate_property(
		self, 
		'scale',
		self.get_scale(), 
		Vector2(2.0, 2.0),
		0.3,
		Tween.TRANS_QUAD, 
		Tween.EASE_OUT
	)
	$RiseEffect.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_RiseEffect_tween_completed(object, key):
	pass
	#queue_free()


func _on_CollectArea_body_entered(body):
	if body.get_parent().get_name () == 'Player':
		if body.get_parent().can_increase_health(1):
			body.get_parent().increase_health(1)
			queue_free()
