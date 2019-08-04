extends KinematicBody2D

# The orb.
var orb_node = null

# Node that contains the orb patterns.
var patterns_node = null

# The current orb pattern.
var current_pattern = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	orb_node = get_node("../orb")
	patterns_node = get_node("PatternsScene/Patterns")
	
	# Test setting the orb pattern
	set_orb_pattern(current_pattern)
	orb_node.fire()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# Set the pattern the orb travels in.
#  number - which of the patterns to set it to
func set_orb_pattern(number : int):
	if number < patterns_node.get_child_count():
		orb_node.set_pattern(patterns_node.get_child(number))
	else:
		print("All patterns done! I think I die now?")