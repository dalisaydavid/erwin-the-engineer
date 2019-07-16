extends Node2D

var velocity = Vector2(0,0)
var direction = 'right'
var move_speed = 50000 
var motion = 0.0
signal imploded

func _ready():
	set_process(true)
	
func _process(delta):
#	if get_node('Timer').is_stopped():
#		queue_free()
		
	#velocity = Vector2(0,0)
	set_velocity()
	motion = velocity * delta
	$KinematicBody2D.move_and_slide(motion)

func set_velocity():
	if direction == 'up':
		velocity.y = -move_speed
	elif direction == 'down':
		velocity.y = move_speed
	elif direction == 'left':
		velocity.x = -move_speed
	elif direction == 'right':
		velocity.x = move_speed
	
func set_direction(direction):
	self.direction = direction

func _on_Area2D_body_entered(body):
	$AnimationPlayer.play('ChangeSize')
	if body == $KinematicBody2D or body.get_parent().get_name() == 'Player':
		return

#	queue_free()

func implode():
	var bodies_in_dimension_hole = $KinematicBody2D/DimensionHole.get_overlapping_bodies()
	
	var alive_so_far = []
	var all_alive = true
	for body in bodies_in_dimension_hole:
		if body.get_parent().get_name() == 'Player':
			get_tree().quit()
			
		if not body.get_parent().is_in_group('black_holeable'):
			continue
		
		if body.get_parent().is_alive:
			alive_so_far.append(body.get_parent())
		else:
			for npc in alive_so_far:
				npc.toggle_type()
			body.get_parent().toggle_type()
			all_alive = false
	
	if all_alive:
		if len(alive_so_far) == 1:
			alive_so_far[0].toggle_type()
		else:
			for npc in alive_so_far:
				npc.queue_free()
		
	emit_signal('imploded')
	queue_free()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'ChangeSize':
		implode()
