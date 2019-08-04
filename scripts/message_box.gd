extends Node2D

# The icon to show (who's talking).
enum { CAT_NEUTRAL, CAT_FACEPAW, CAT_SHOW_TEETH, CAT_SWEAT }

# Nodes to keep track of.
onready var paw_node = get_node("MessageBox/BoxSprite/Label/PawSprite")
onready var cat_node = get_node("MessageBox/CatSprite")
onready var box_node = get_node("MessageBox/BoxSprite")
onready var label_node = get_node("MessageBox/BoxSprite/Label")
onready var animation_player = get_node("MessageBox/AnimationPlayer")

export(Texture) var cat_neutral_texture
export(Texture) var cat_facepaw_texture
export(Texture) var cat_show_teeth_texture
export(Texture) var cat_sweat_texture

# Message information.
class Message:
	var icon
	var message

var messages = []
var current_message = 0

var callback_object = null
var callback_method = ""

# State machine.
enum { ENTER, SHOW_MESSAGES, LEAVE }
var state = ENTER

# Called when the node enters the scene tree for the first time.
func _ready():
	add_message(CAT_FACEPAW, "Don't tell me...\nThis is supposed to be riveting dialogue?")
	add_message(CAT_SHOW_TEETH, "This makes me so mad!")
	show_messages(self, "test_callback")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state == SHOW_MESSAGES:
		if Input.is_action_just_pressed("ui_accept"):
			# Show next message.
			current_message += 1
			if current_message < messages.size():
				show_current_message()
			else:
				state = LEAVE
				animation_player.play_backwards("Enter")

# Add a new message to the queue.
func add_message(icon, message):
	var mes = Message.new()
	mes.icon = icon
	mes.message = message
	messages.append(mes)

# Show the current message.
func show_current_message():
	var mes = messages[current_message]
	set_icon(mes.icon)
	label_node.set_text(mes.message)

# Set the talker icon.
func set_icon(icon):
	if icon == CAT_NEUTRAL:
		cat_node.texture = cat_neutral_texture
	elif icon == CAT_FACEPAW:
		cat_node.texture = cat_facepaw_texture
	elif icon == CAT_SHOW_TEETH:
		cat_node.texture = cat_show_teeth_texture
	elif icon == CAT_SWEAT:
		cat_node.texture = cat_sweat_texture

# Show the queue of messages.
func show_messages(call_object, call_method):
	if messages.size() == 0:
		push_warning("Tried to show empty message queue! Queue messages first!")
	
	callback_object = call_object
	callback_method = call_method
	set_icon(messages[0].icon)
	
	animation_player.connect("animation_finished", self, "animation_finished")
	animation_player.play("Enter")
	current_message = 0
	visible = true
	label_node.set_text("")
	paw_node.visible = false
	state = ENTER

# Handle the finished animation.
func animation_finished(e):
	if state == ENTER:
		state = SHOW_MESSAGES
		show_current_message()
	elif state == LEAVE :
		visible = false
		callback_object.call(callback_method)

func test_callback():
	print("It worked")