extends Node2D

# Array of positions to follow.
var positions = []

# Which position in the position list is the current one.
var current_position = 0

# The state the bullet is currently in.
enum {NEUTRAL, FIRED, STOPPED, RETURN}
var state = NEUTRAL

# The speed of the bullet in pixels / second.
const speed = 2400.0

# The orb.
var orb_node = null

# The line node that shows the orb's trail.
var trail_line_node = null

# Information about trails.
var trails = []

# Information about a trail.
class TrailNode:
	# How many points this frame contains.
	var num_points

	# How long (in seconds) this frame was.
	var time

# How long a trail should stay on the screen (in seconds).
const trail_time = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	orb_node = get_node("Sprite")
	trail_line_node = get_node("TrailLine")

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
	clear_old_lines()

	if state == FIRED:
		travel(delta)
	else:
		fire()

# Travel along the determined path.
#  delta - time since last frame in seconds
func travel(delta):
	# Determine how long to travel this frame.
	var distance_to_travel = speed * delta

	# Add starting point for trailing line.
	trail_line_node.add_point(orb_node.transform.origin)
	var points_added = 1

	# Travel along the nodes as long as there is distance left to travel.
	while distance_to_travel > 0.0:
		# Figure out next node.
		var to_node = positions[current_position] - orb_node.transform.origin
		var distance_to_node = to_node.length()

		# Move toward it.
		orb_node.transform.origin += to_node.clamped(min(distance_to_travel, distance_to_node))

		# TODO: Check collision with player.

		# If we reached the node, go to the next one.
		if distance_to_travel >= distance_to_node:
			# Add a line point at the node's position.
			trail_line_node.add_point(positions[current_position])

			orb_node.transform.origin = positions[current_position]
			points_added += 1
			current_position += 1

			# Have we reached the final node?
			if current_position >= positions.size():
				state = STOPPED
				break
		else:
			# Add a line point at the current position
			trail_line_node.add_point(orb_node.transform.origin)
			points_added += 1

		distance_to_travel -= distance_to_node

	# Add information to trails.
	var frame = TrailNode.new()
	frame.num_points = points_added
	frame.time = delta
	trails.append(frame)

# Clear old line trails.
func clear_old_lines():
	# Clear out previous trails if they're too old.
	var frame = trails.size() - 1
	var time = 0.0
	while (frame >= 0 and time < trail_time):
		time += trails[frame].time
		frame -= 1

	if time > trail_time:
		frame += 1
		var i = 0
		while i <= frame:
			for point in range(trails[0].num_points):
				trail_line_node.remove_point(0)

			i += 1
			trails.remove(0)

# Fire the bullet!
func fire():
	state = FIRED
	current_position = 0
