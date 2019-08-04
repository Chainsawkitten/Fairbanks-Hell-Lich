extends Node2D

onready var animation_player = get_node("AnimationPlayer")

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.connect("animation_finished", self, "finished")
	animation_player.play("explode")

# Called when the animation has finished.
func finished(e):
	queue_free()
