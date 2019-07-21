extends Node2D

var velocity = Vector2(0,0)
var direction = ''
export var move_speed = 25000 
var motion = 0.0
func _ready():
	set_process(true)

func set_velocity_towards_position(from_position, end_position):
	velocity = (end_position - from_position).normalized() * move_speed
	
func _process(delta):
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

func _on_DeathTimer_timeout():
	queue_free()


func _on_AttackArea_body_entered(body):
	if body.get_parent().get_name() == 'Player':
		body.get_parent().damage(1)
