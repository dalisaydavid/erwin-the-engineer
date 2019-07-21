extends Node2D

var walk_speed = 120
var velocity
var target
var can_move = true
var direction = Vector2(0, 0)
export var wait_time = 3
export var move_randomly = true
signal dimension_changed
export (NodePath) var player_path
export var shoot_direction = 'right'
var player
var is_following

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)
	get_tree().get_root().get_node('Root/Start').connect('player_started', self, 'can_follow')
	
	$MoveAnimationPlayer.play('Move')
	
	if player_path:
		player = get_node(player_path)
		
	$ShootTimer.wait_time = randi() % 5 + 1
	
func shoot_projectile():
	var new_projectile = load('res://scenes/EnemyProjectile.tscn').instance()
	new_projectile.set_velocity_towards_position($KinematicBody2D.global_position, player.get_node('KinematicBody2D').global_position)
	new_projectile.global_position = Vector2($KinematicBody2D.global_position.x, $KinematicBody2D.global_position.y)
	get_parent().add_child(new_projectile)
#	emit_signal('shot_projectile')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func follow_move(delta):
	var dir = (player.get_node('KinematicBody2D').global_position - $KinematicBody2D.global_position).normalized()
	$KinematicBody2D.move_and_slide(dir*walk_speed)

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
	$KinematicBody2D.move_and_slide(direction*walk_speed)

	if direction.x < 0:
		$KinematicBody2D/AliveSprite.flip_h = false
	else:
		$KinematicBody2D/AliveSprite.flip_h = true

func _on_ShootTimer_timeout():
	shoot_projectile()	
