extends Sprite

# The position when the scene was loaded.
var starting_pos = Vector2(0, 0)

# Timer to control movement.
var timer = 0.0

# The distance in pixels to move.
export var move_distance = 3

# How fast to move.
export var move_speed = 2.0

# Called when the node enters the scene tree for the first time.
func _ready():
	starting_pos = transform.origin
	timer = randf() * PI * 2.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	
	transform.origin = starting_pos + Vector2(sin(timer * move_speed), sin(timer * move_speed * 0.7 + 1.2))
