extends Node2D

# The icon to show (who's talking).
enum { CAT_NEUTRAL, CAT_FACEPAW, CAT_SHOW_TEETH, CAT_SWEAT }

# Nodes to keep track of.
onready var paw_node = get_node("MessageBox/BoxSprite/Label/PawSprite")
onready var cat_node = get_node("MessageBox/CatSprite")
onready var box_node = get_node("MessageBox/BoxSprite")
onready var label_node = get_node("MessageBox/BoxSprite/Label")

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

# Todo: Callback when having played all messages.

# Called when the node enters the scene tree for the first time.
func _ready():
	add_message(CAT_FACEPAW, "Don't tell me...\nThis is supposed to be riveting dialogue?")
	add_message(CAT_SHOW_TEETH, "This makes me so mad!")
	#show_messages()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		# Show next message.
		current_message += 1
		if current_message < messages.size():
			show_current_message()
		else:
			visible = false
			# TODO Callback

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
func show_messages():
	current_message = 0
	visible = true