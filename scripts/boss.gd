extends KinematicBody2D

# The orb.
var orb_node = null

# Node that contains the orb patterns.
var patterns_node = null

# The current orb pattern.
var current_pattern = 0

# The different kinds of states.
enum { NORMAL, CASTING, DAMAGED }

# Current state of the boss
var state = NORMAL

# Hand nodes
var normal_hands = null
var damaged_hands = null
var casting_hands = null

# Timer for state changes.
var timer = 0

const damaged_time = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	orb_node = get_node("../orb")
	patterns_node = get_node("PatternsScene/Patterns")
	
	normal_hands = get_node("body/HandsNormal")
	damaged_hands = get_node("body/HandsDamaged")
	casting_hands = get_node("body/HandsCasting")
	
	# Test setting the orb pattern
	set_orb_pattern(current_pattern)
	fire()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	
	# State machine.
	if state == DAMAGED:
		if timer > damaged_time:
			set_state(NORMAL)
	elif state == CASTING:
		if orb_node.state != orb_node.FORESIGHT:
			set_state(NORMAL)

# Set the pattern the orb travels in.
#  number - which of the patterns to set it to
func set_orb_pattern(number : int):
	if number < patterns_node.get_child_count():
		orb_node.set_pattern(patterns_node.get_child(number))
	else:
		print("All patterns done! I think I die now?")

# Fire the orb!
func fire():
	orb_node.fire()
	set_state(CASTING)

# Set which state the boss should be in.
#  new_state - the new state.
func set_state(new_state):
	timer = 0
	state = new_state
	
	# Hand visibility.
	if state == NORMAL:
		normal_hands.visible = true
		damaged_hands.visible = false
		casting_hands.visible = false
	elif state == DAMAGED:
		normal_hands.visible = false
		damaged_hands.visible = true
		casting_hands.visible = false
	elif state == CASTING:
		normal_hands.visible = false
		damaged_hands.visible = false
		casting_hands.visible = true