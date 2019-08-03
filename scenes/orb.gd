extends Node2D

# Array of positions to follow.
var positions = []

# Which position in the position list is the current one.
var current_position = 0

# The state the bullet is currently in.
enum {NEUTRAL, FIRED, STOPPED, RETURN}
var state = NEUTRAL

# The speed of the bullet in pixels / second.
const speed = 600.0

# Called when the node enters the scene tree for the first time.
func _ready():
	# Hardcode some values for testing purposes.
	# We are going to need some editor to make these.
	positions.append(Vector2(0.0, 0.0))
	positions.append(Vector2(200.0, 0.0))
	positions.append(Vector2(100.0, 100.0))
	positions.append(Vector2(50.0, 25.0))
	positions.append(Vector2(75.0, 200.0))
	positions.append(Vector2(30.0, 40.0))
	
	# Test firing the bullet.
	fire()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state == FIRED:
		travel(delta)

# Travel along the determined path.
#  delta - time since last frame in seconds
func travel(delta):
	# Determine how long to travel this frame.
	var distance_to_travel = speed * delta
	
	# Travel along the nodes as long as there is distance left to travel.
	while distance_to_travel > 0.0:
		# Figure out next node.
		var to_node = positions[current_position] - transform.origin
		var distance_to_node = to_node.length()
		
		# Move toward it.
		transform.origin += to_node.clamped(min(distance_to_travel, distance_to_node))
		
		# TODO: Check collision with player.
		
		# If we reached the node, go to the next one.
		if distance_to_travel >= distance_to_node:
			transform.origin = positions[current_position]
			current_position += 1
			
			# Have we reached the final node?
			if current_position >= positions.size():
				state = STOPPED
				break
		
		distance_to_travel -= distance_to_node
	

# Fire the bullet!
func fire():
	state = FIRED
	current_position = 0
