extends Node2D

var velocity = Vector2()
var motion = 0.0
export var walk_speed = 12000 
signal dimension_changed
signal ammo_changed
var last_direction = 'right'
var projectile_scene = load('res://scenes/Projectile.tscn')
export var ammo = 2
export var blink_distance = 10
var health = 3
var normal_modulate
signal damaged
signal shot_projectile
var projectile_type = 'vortex'
var mouse_projectile_position
var is_invincible = false
var mouse_in_blink_range = false
export var max_ammo = 10

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	set_physics_process(true)
	set_process_input(true)
	
	normal_modulate = $KinematicBody2D/Sprite.modulate
	
	$DamageTimer.connect('timeout', self, 'change_color_to_normal')
	
func _physics_process(delta):
	if health <= 0:
		get_tree().quit()
		
	# Handle movement inputs every frame.
	velocity.y = 0
	velocity.x = 0

	handle_movement()
	motion = velocity * delta
	
	if velocity.x == 0 and velocity.y == 0:
		pass
	elif last_direction == 'left':
		$KinematicBody2D/ErwinBody.flip_h = false
		$KinematicBody2D/ErwinGun.flip_h = false

	elif last_direction == 'right':
		$KinematicBody2D/ErwinBody.flip_h = true
		$KinematicBody2D/ErwinGun.flip_h = true

		
	if abs(velocity.x) > 0.01 or abs(velocity.y) > 0.01:
		play_animation('Move')
	else:
		play_animation('Idle')
		
	$KinematicBody2D.move_and_slide(motion)


func toggle_dimension():
	emit_signal('dimension_changed')

func _input(event):
	if event.is_action_pressed('toggle_dimension'):
		pass #		toggle_dimension()
	elif event.is_action_released('shoot'):
		if ammo > 0:
			shoot_projectile_animation()
	elif event.is_action_pressed('ui_right'):
		blink('right')
	elif event.is_action_pressed('ui_left'):
		blink('left')
	elif event.is_action_pressed('ui_up'):
		blink('up')
	elif event.is_action_pressed('ui_down'):
		blink('down')
	

func can_blink(potential_position):
	var tile_position = get_tree().get_root().get_node('Root/DungeonTilemap').world_to_map(potential_position)
	var tile = get_tree().get_current_scene().get_node('DungeonTilemap').get_cellv(tile_position)
	return tile == 0

func blink(direction):
	if ammo < 2:
		return
		
	# Create projectile before blinking.
	var new_projectile = projectile_scene.instance()
	new_projectile.connect('imploded', self, 'increase_ammo_after_blink')
#	new_projectile.set_direction(last_direction)
#	new_projectile.type = projectile_type
#	var projectile_spawn = $KinematicBody2D.get_node(last_direction + 'Position')
	new_projectile.global_position = Vector2($KinematicBody2D.global_position.x, $KinematicBody2D.global_position.y)
	get_parent().add_child(new_projectile)
	decrease_ammo(2)
	emit_signal('shot_projectile')
	
	# Blink to new location.
#	$KinematicBody2D.global_position = get_global_mouse_position()
	var new_position = Vector2($KinematicBody2D.global_position.x, $KinematicBody2D.global_position.y)
	if direction == 'up':
		new_position.y -= blink_distance
	elif direction == 'down':
		new_position.y += blink_distance
	elif direction == 'left':
		new_position.x -= blink_distance
	elif direction == 'right':
		new_position.x += blink_distance
	
	if can_blink(new_position):
		$KinematicBody2D.global_position = new_position
	
	
func increase_ammo():
	if ammo >= max_ammo:
		return
		
	ammo += 1
	emit_signal('ammo_changed')
	
func increase_ammo_after_blink():
	if ammo >= max_ammo:
		return
		
	ammo += 2
	emit_signal('ammo_changed')
	
func decrease_ammo(amount=1):
	if ammo <= 0:
		return
		
	ammo -= amount
	emit_signal('ammo_changed')

func shoot_projectile_animation():
	$ErwinGunAnimationPlayer.play('GunShoot')
	
func shoot_projectile():
	var new_projectile = projectile_scene.instance()
	new_projectile.connect('imploded', self, 'increase_ammo')
	new_projectile.set_direction(last_direction)
#	mouse_projectile_position = get_global_mouse_position()
#	new_projectile.set_velocity_towards_position($KinematicBody2D.global_position, mouse_projectile_position)
	new_projectile.type = projectile_type
	var projectile_spawn = $KinematicBody2D.get_node(last_direction + 'Position')
	new_projectile.global_position = Vector2(projectile_spawn.global_position.x, projectile_spawn.global_position.y)
	get_parent().add_child(new_projectile)
	decrease_ammo()
	emit_signal('shot_projectile')

var keys_pressed = []



func update_pressed(key_id, append=false):
	var key = keys_pressed.find(key_id)
	if key == -1 and append:
		keys_pressed.append(key_id)
	
	if key != -1 and not append:
		keys_pressed.remove(key)

func handle_movement():
	
	# Process input before handling it to prevent priority problem
	if (Input.is_key_pressed(KEY_A)):
		update_pressed('left', true)
	else:
		update_pressed('left')
		
	if (Input.is_key_pressed(KEY_D)):
		update_pressed('right', true)
	else:
		update_pressed('right')
		
	if (Input.is_key_pressed(KEY_W)):
		update_pressed('up', true)
	else:
		update_pressed('up')
		
	if (Input.is_key_pressed(KEY_S)):
		update_pressed('down', true)
	else:
		update_pressed('down')
	
	# Handle only last input
	var last_pressed = keys_pressed.back()
	if last_pressed:
		
		if (last_pressed == 'left'):
			velocity.x = -walk_speed
			velocity.y = 0
		
		if (last_pressed == 'right'):
			velocity.x = walk_speed
			velocity.y = 0
		
		if (last_pressed == 'up'):
			velocity.x = 0
			velocity.y = -walk_speed
		
		if (last_pressed == 'down'):
			velocity.x = 0
			velocity.y = walk_speed
		
		last_direction = last_pressed

func damage(amount):
	if is_invincible:
		return
	
	health -= amount
	change_color_to_damage()
	$DamageTimer.start()
	emit_signal('damaged')
	
func change_color_to_damage():
	$KinematicBody2D/ErwinBody.modulate = Color(1,0,0)
	is_invincible = true
	
func change_color_to_normal():
	$KinematicBody2D/ErwinBody.modulate = normal_modulate
	is_invincible = false

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'GunShoot':
		shoot_projectile()


func _on_BlinkRange_mouse_entered():
	mouse_in_blink_range = true


func _on_BlinkRange_mouse_exited():
	mouse_in_blink_range = false


func play_animation(anim):
	if $ErwinBodyAnimationPlayer.current_animation != anim:
		$ErwinBodyAnimationPlayer.play(anim)