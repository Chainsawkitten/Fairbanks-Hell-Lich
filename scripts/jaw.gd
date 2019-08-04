extends Sprite

# The y when the scene was loaded.
var starting_y = 0.0

# Timer to control movement.
var timer = 0.0

# The height in pixels to move.
const move_height = 3

# How fast to move.
var move_speed = 2.0

# Possible states.
enum { BREATHE, DEAD }

# Current state.
var state = BREATHE

# Gravity in pixels / second^2
const gravity = 50.0

# Current velocity.
var velocity = Vector2(0, 0)

const angular_velocity = 0.4

# Called when the node enters the scene tree for the first time.
func _ready():
	starting_y = transform.origin.y - move_height / 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	
	if state == BREATHE:
		transform.origin.y = floor(starting_y + sin(timer * move_speed) * move_height)
	
	if state == DEAD:
		velocity.y += gravity * delta
		transform.origin += velocity * delta
		rotation += angular_velocity * delta
