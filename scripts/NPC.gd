extends Node2D

export var is_alive = 1
export var walk_speed = 100 
export (NodePath) var patrol_path
var patrol_points
var patrol_index = 0
var velocity
var target
signal dimension_changed

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)
	get_tree().get_root().get_node('Root/Player').connect('dimension_changed', self, '_on_Player_dimension_changed')
	
	if patrol_path:
		patrol_points = get_node(patrol_path).curve.get_baked_points()
		
	show_sprite_types()
#		print(patrol_points)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	handle_movement(delta)
#	var velocity = Vector2(walk_speed,0)
#	var motion = velocity * delta
#	$KinematicBody2D.move_and_collide(motion)

func handle_movement(delta):
	if not is_alive:
		return
		
	if not patrol_path:
	    return
		
	var target = patrol_points[patrol_index]
	if $KinematicBody2D.global_position.distance_to(target) < 1:
	    patrol_index = wrapi(patrol_index + 1, 0, patrol_points.size())
	    target = patrol_points[patrol_index]
	velocity = (target - $KinematicBody2D.global_position).normalized() * walk_speed
	if velocity.y < 0:
		$KinematicBody2D/AliveSprite.flip_h = false
	else:
		$KinematicBody2D/AliveSprite.flip_h = true
	$KinematicBody2D.move_and_slide(velocity)

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
	# set_collision()
	set_path()
	
	emit_signal('dimension_changed')


func _on_Player_dimension_changed():
	toggle_type()
	

