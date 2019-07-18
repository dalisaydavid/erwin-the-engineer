extends Node2D

export(String, FILE, '*tscn') var point_path
var velocity = Vector2(0,0)
var direction = 'right'
var move_speed = 50000 
var motion = 0.0
signal implode
signal imploded
var new_velocity = Vector2(500, 0)
export var type = 'vortex'
func _ready():
	set_process(true)
	
func _process(delta):
	var camera = get_tree().get_root().get_node('Root/Camera')
	self.connect('implode', camera, 'start_shake')
	self.connect('imploded', camera, 'stop_shake')
	
	set_velocity()
	motion = velocity * delta
	
	if type == 'vortex':
		if not $AnimationPlayer.is_playing():
			$KinematicBody2D.move_and_slide(motion)

	elif type == 'frog':
		var collision_info = $KinematicBody2D.move_and_collide(new_velocity * delta)
		if collision_info:
			new_velocity = new_velocity.bounce(collision_info.normal)

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
	if body == $KinematicBody2D or body.get_parent().get_name() == 'Player':
		return
	$AnimationPlayer.play('ChangeSize')
	emit_signal('implode')
	implode()
#	queue_free()

func implode_object(object):
	if point_path:
		var new_point = load(point_path).instance()
		var root = get_tree().get_root().get_node('Root')
		root.add_child(new_point)
		new_point.global_position = object.get_node('KinematicBody2D').global_position

	object.get_node('AnimationPlayer').play('Fall')

func implode():
	var bodies_in_dimension_hole = $KinematicBody2D/DimensionHole.get_overlapping_bodies()
	
	var alive_so_far = []
	var all_alive = true
	for body in bodies_in_dimension_hole:
#		if body.get_parent().get_name() == 'Player':
#			get_tree().quit()
			
		if not body.get_parent().is_in_group('black_holeable'):
			continue
		
#		body.get_parent().toggle_type()
#		object.get_node('AnimationPlayer').play('Fall')
		implode_object(body.get_parent())
	
	

func set_shoot_time_scale(time_scale):
	pass

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'ChangeSize':
		queue_free()
		emit_signal('imploded')
		
