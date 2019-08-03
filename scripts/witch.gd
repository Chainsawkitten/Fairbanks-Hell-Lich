extends KinematicBody2D

# The current speed of the witch (0-1).
var speed = Vector2(0.0, 0.0)

# The max speed in pixels / second.
const max_speed = 180.0

# The max rotation to use when tilting the witch based on her horizontal speed.
const max_rotation = PI * 0.1

# Seconds it takes to go from 0 to max_speed
const time_to_max_speed = 0.1

# Joystick deadzone.
const deadzone = 0.25

# Whether the character can currently be controlled. false in cutscenes / dialog.
var controllable = true

# Size of the screen
const screen_size = Vector2(480, 270)
# Number of pixels in from the edges of the screen that you can't move beyond.
const room_margin = Vector2(10, 14)
# Coordinates of top-left and bottom-right corners
const room_top_left = room_margin
const room_bot_right = screen_size - room_margin
# Number of pixels inside the room that slows down motion towards the edges.
const room_padding = Vector2(20, 20)


var animation_node = null

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_node = get_node("AnimationPlayer")
	animation_node.play("Idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if controllable:
		move(delta)
		
		# Tilt the witch depending on the horizontal speed.
		rotation = speed.x * max_rotation
	
	animation_node.playback_speed = 2.0 + speed.length()

# Handle the movement of the witch.
#  delta - elasped time since the previous frame
func move(delta):
	# Poll what the desired speed is, then accelerate/decelerate to that speed.
	var desired_speed = Vector2(0.0, 0.0)
	
	# Joystick.
	var joy_input = Vector2(Input.get_joy_axis(0, 0), Input.get_joy_axis(0, 1))
	if abs(joy_input.x) > deadzone:
		desired_speed.x = joy_input.x
	if abs(joy_input.y) > deadzone:
		desired_speed.y = joy_input.y
	
	# Keyboard / D-pad
	if Input.is_action_pressed("ui_left"):
		desired_speed.x -= 1.0
	if Input.is_action_pressed("ui_right"):
		desired_speed.x += 1.0
	if Input.is_action_pressed("ui_up"):
		desired_speed.y -= 1.0
	if Input.is_action_pressed("ui_down"):
		desired_speed.y += 1.0
	
	# Clamp the desired speed to 0-1. This way we move the same speed even if moving diagonally.
	desired_speed = desired_speed.clamped(1.0)
	
	# Accelerate toward the desired speed.
	var difference = desired_speed - speed
	speed += difference.clamped(delta / time_to_max_speed)
	speed = speed.clamped(1.0)
	
	# Calculate distance to room edges
	var dist_top_left = transform.origin - room_top_left
	var dist_bot_right = room_bot_right - transform.origin
	# Calculate room edge speed penalty
	var penalty_top_left = dist_top_left/room_padding
	var penalty_bot_right = dist_bot_right/room_padding
	# Clamp speed penalty between 0 and 1 component-wise
	penalty_top_left.x = clamp(penalty_top_left.x, 0, 1)
	penalty_top_left.y = clamp(penalty_top_left.y, 0, 1)
	penalty_bot_right.x = clamp(penalty_bot_right.x, 0, 1)
	penalty_bot_right.y = clamp(penalty_bot_right.y, 0, 1)
	# Clamp speed by penalty
	speed.x = clamp(speed.x, -penalty_top_left.x, penalty_bot_right.x)
	speed.y = clamp(speed.y, -penalty_top_left.y, penalty_bot_right.y)

func _physics_process(delta):
	if controllable:
		# Apply the motion, and go from 0-1 to 0-max_speed.
		# transform.origin += speed * delta * max_speed
		var collision = move_and_collide(speed * delta * max_speed)
		if collision:
			transform.origin = Vector2(233, 192)
			print("You die")
			# Try this instead if you want bouncy boss:
			# speed = speed.bounce(collision.normal)
		
	# Prevent going out of bounds
	#transform.origin.x = clamp(transform.origin.x, room_top_left.x, room_bot_right.x)
	#transform.origin.y = clamp(transform.origin.y, room_top_left.y, room_bot_right.y)
