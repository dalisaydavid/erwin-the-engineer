extends Node2D

var velocity = Vector2()
var motion = 0.0
export var walk_speed = 10000 
signal dimension_changed
signal ammo_changed
var last_direction = ''
var projectile_scene = load('res://scenes/Projectile.tscn')
export var ammo = 2

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	set_process(true)
	set_process_input(true)
	
func _process(delta):
	# Handle movement inputs every frame.
	velocity.y = 0
	velocity.x = 0

	handle_movement()
	motion = velocity * delta
	$KinematicBody2D.move_and_slide(motion)

func toggle_dimension():
	emit_signal('dimension_changed')

func _input(event):
	if event.is_action_pressed('toggle_dimension'):
		toggle_dimension()
	elif event.is_action_released('shoot'):
		if ammo > 0:
			shoot_projectile()

func increase_ammo():
	ammo += 1
	emit_signal('ammo_changed')
	
func decrease_ammo():
	ammo -= 1
	emit_signal('ammo_changed')

func shoot_projectile():
	var new_projectile = projectile_scene.instance()
	new_projectile.connect('imploded', self, 'increase_ammo')
	new_projectile.set_direction(last_direction)
	var projectile_spawn = $KinematicBody2D.get_node(last_direction + 'Position')
	new_projectile.global_position = Vector2(projectile_spawn.global_position.x, projectile_spawn.global_position.y)
	get_parent().add_child(new_projectile)
	decrease_ammo()

func handle_movement():
	if (Input.is_key_pressed(KEY_A)):
		velocity.x = -walk_speed
		last_direction = 'left'
	elif (Input.is_key_pressed(KEY_D)):
		velocity.x =  walk_speed
		last_direction = 'right'
	elif (Input.is_key_pressed(KEY_W)):
		velocity.y = -walk_speed
		last_direction = 'up'
	elif (Input.is_key_pressed(KEY_S)):
		velocity.y =  walk_speed
		last_direction = 'down'
