extends KinematicBody2D

# The orb.
var orb_node = null

# Node that contains the orb patterns.
var patterns_node = null

# The current orb pattern.
var current_pattern = 1

# The different kinds of states.
enum { NORMAL, CASTING, DAMAGED, JAW_DROP, DYING }

# Current state of the boss
var state = NORMAL

# Hand nodes
var normal_hands = null
var damaged_hands = null
var casting_hands = null

# Timer for state changes.
var timer = 0

const damaged_time = 1.0
const jaw_drop_time = 3.0

# How fast the boss should fall while dying. In pixels / second
const dying_speed = 20.0

# Explosion scene to be spawned when dying.
var explosion = preload("res://scenes/explosion.tscn")

var time_to_next_explosion = 0
const time_between_explosions = 0.05

# Called when the node enters the scene tree for the first time.
func _ready():
	orb_node = get_node("../orb")
	patterns_node = get_node("PatternsScene/Patterns")
	
	normal_hands = get_node("body/HandsNormal")
	damaged_hands = get_node("body/HandsDamaged")
	casting_hands = get_node("body/HandsCasting")
	
	# Test setting the orb pattern
	fire()
	set_orb_pattern(current_pattern)

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
	elif state == JAW_DROP:
		if timer > jaw_drop_time:
			set_state(DYING)
	elif state == DYING:
		transform.origin.y += delta * dying_speed
		explode(delta)

# Set the pattern the orb travels in.
#  number - which of the patterns to set it to
func set_orb_pattern(number : int):
	if number < patterns_node.get_child_count():
		orb_node.set_pattern(patterns_node.get_child(number))
	else:
		set_state(JAW_DROP)

# Fire the orb!
func fire():
	orb_node.fire()
	set_state(CASTING)

func hit():
	set_state(DAMAGED)
	current_pattern+=1
	set_orb_pattern(current_pattern)

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
	elif state == JAW_DROP:
		normal_hands.visible = false
		damaged_hands.visible = true
		casting_hands.visible = false
		
		get_node("CollisionShape2D").disabled = true
		
		# Drop jaw.
		var jaw_node = get_node("Head/jaw")
		jaw_node.state = jaw_node.DEAD
	elif state == DYING:
		pass

# Spawn explosions.
func explode(delta):
	time_to_next_explosion -= delta
	
	while time_to_next_explosion < 0:
		# Spawn an explosion.
		var explosion_instance = explosion.instance()
		get_parent().add_child(explosion_instance)
		var position = transform.origin
		var min_pos = Vector2(-70, -20)
		var max_pos = Vector2(70, 200)
		position += Vector2(randf(), randf()) * (max_pos - min_pos) + min_pos
		explosion_instance.transform.origin = position
		
		
		time_to_next_explosion += time_between_explosions