extends Node2D

# The current speed of the witch.
var speed = Vector2(0.0, 0.0)

# The max speed in pixels / second.
const max_speed = 120.0

# The max rotation to use when tilting the witch based on her horizontal speed.
const max_rotation = PI * 0.1

# Whether the character can currently be controlled. false in cutscenes / dialog.
var controllable = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if controllable:
		move(delta)
		
		# Tilt the witch depending on the horizontal speed.
		rotation = speed.x / max_speed * max_rotation

# Handle the movement of the witch.
#  delta - elasped time since the previous frame
func move(delta):
	# Poll what the desired speed is, then accelerate/decelerate to that speed.
	# TODO: Handle joystick.
	var desired_speed = Vector2(0.0, 0.0)
	
	if Input.is_action_pressed("ui_left"):
		desired_speed.x -= 1.0
	if Input.is_action_pressed("ui_right"):
		desired_speed.x += 1.0
	if Input.is_action_pressed("ui_up"):
		desired_speed.y -= 1.0
	if Input.is_action_pressed("ui_down"):
		desired_speed.y += 1.0
	
	# Clamp the desired speed to 0-1. This way we move the same speed even if moving diagonally.
	var desired_speed_length = desired_speed.length()
	if (desired_speed_length > 1.0):
		desired_speed /= desired_speed_length
	
	# Now go from 0-1 to 0-max_speed.
	desired_speed *= max_speed
	
	# Set the speed to the desired speed.
	# TODO: Acceleration
	speed = desired_speed
	
	transform.origin += speed * delta
