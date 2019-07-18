extends Camera2D

export (NodePath) var player_path
var player
var shake_on
export var shake_amount = 1.5
export var shake_timer = 2.0

func _ready():
	set_process(true)
	shake_on = false
	
	player = get_node(player_path)
#	player.connect('shot_projectile', self, 'start_shake')
	
#	$ShakeTimer.wait_time = shake_timer
#	$ShakeTimer.connect('timeout', self, 'stop_shake')

func _process(delta):
	global_position = player.get_node('KinematicBody2D').global_position
#	position = get_tree().get_root().get_node('Root/Projectile').global_position

	if shake_on:
		shake()

func start_shake():	
#	$ShakeTimer.start()
	shake_on = true

func stop_shake():
	shake_on = false
	
func shake():
	if shake_on:
		self.set_offset(Vector2( \
			rand_range(-1.0, 1.0) * shake_amount, \
			rand_range(-1.0, 1.0) * shake_amount \
		))