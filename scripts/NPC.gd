extends Node2D

export var is_alive = 1
var walk_speed = 120
export (NodePath) var patrol_path
var patrol_points
var patrol_index = 0
var velocity
var target
var can_move = true
var direction = Vector2(0, 0)
export var wait_time = 3
export var move_randomly = true
signal dimension_changed
export (NodePath) var player_path
var player
var is_following

# Called when the node enters the scene tree for the first time.
func _ready():
	
	set_physics_process(true)
	get_tree().get_root().get_node('Root/Player').connect('dimension_changed', self, '_on_Player_dimension_changed')
	get_tree().get_root().get_node('Root/Start').connect('player_started', self, 'can_follow')
	if patrol_path:
		patrol_points = get_node(patrol_path).curve.get_baked_points()
		
	show_sprite_types()
	
	$MoveTimer.wait_time = (randi() % wait_time)+1
	$MoveTimer.connect('timeout', self, '_on_MoveTimer_timeout')
	
	if player_path:
		player = get_node(player_path)
		
	is_following = false

func can_follow():
	is_following = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if player_path and is_following:
		follow_move(delta)
	elif move_randomly:
		random_move()
	else:
		move_on_path(delta)
#	handle_movement(delta)

func follow_move(delta):
	var dir = (player.get_node('KinematicBody2D').global_position - $KinematicBody2D.global_position).normalized()
	velocity = dir*walk_speed
	$KinematicBody2D.move_and_slide(velocity)
	detect_state(velocity) 
	

func move_on_path(delta):
	
	if not is_alive:
		return
		
	if not patrol_path:
	    return
		
	var velocity = Vector2(walk_speed,0)
	var motion = velocity * delta
	var target = patrol_points[patrol_index]
	if $KinematicBody2D.global_position.distance_to(target) < 1:
	    patrol_index = wrapi(patrol_index + 1, 0, patrol_points.size())
	    target = patrol_points[patrol_index]
	velocity = (target - $KinematicBody2D.global_position).normalized() * walk_speed
	
	$KinematicBody2D.move_and_slide(velocity)
	detect_state(velocity)


func _on_MoveTimer_timeout():
	if not can_move:
		can_move = true
		direction = Vector2(random(), 0).normalized()
	else:
		can_move = false

func random():
    randomize()
    return randi()%21 - 10 # range is -10 to 10

func random_move():
	var	velocity = direction*walk_speed
	$KinematicBody2D.move_and_slide(velocity)
	detect_state(velocity)


func show_sprite_types():
	$KinematicBody2D/AliveSprite.set_visible(is_alive)
	$KinematicBody2D/ObjectSprite.set_visible(not is_alive)
	
func set_collision():
	if is_alive:
		$KinematicBody2D/CollisionShape2D.disabled = true
	else:
		$KinematicBody2D/CollisionShape2D.disabled = false
	
func set_path():
	if is_alive and patrol_path:
		patrol_points = get_node(patrol_path).curve.get_baked_points()
	

func toggle_type():
	is_alive = not is_alive
	
	show_sprite_types()
	set_path()
	emit_signal('dimension_changed')

func _on_Player_dimension_changed():
	toggle_type()
	

func _on_DamageArea_body_entered(body):
#	print('damage area body entered ', body.get_parent().get_name())
	if body.get_parent().get_name() == 'Player':
		body.get_parent().damage(1)
		
func play_fall_animation():
	is_alive = false
	play_animation('Fall')

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'Fall':
		queue_free()

func _on_AnimationPlayer_animation_started(anim_name):
	pass

func _on_EarshotArea_body_entered(body):
	pass
	
func detect_state(velocity):
	
	if not is_alive:
		return
	
	if velocity.x < 0:
		$KinematicBody2D/AliveSprite.flip_h = false
	else:
		$KinematicBody2D/AliveSprite.flip_h = true
	
	if abs(velocity.x) > 0.01 or abs(velocity.y) > 0.01:
		play_animation('Jump')
	else:
		play_animation('Idle')
	
func play_animation(anim):
	if $AnimationPlayer.current_animation != anim:
		$AnimationPlayer.play(anim)

