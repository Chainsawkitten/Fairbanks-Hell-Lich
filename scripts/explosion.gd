extends Node2D

onready var animation_player = get_node("AnimationPlayer")

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.connect("animation_finished", self, "finished")
	animation_player.play("explode")
	if Global.has_jawed_boss:
		get_node("AudioStreamPlayer").volume_db = 3
	if !Global.has_played_cutscene.has(get_node("/root/Node2D/CutsceneController").CUTSCENE.ENDING):
		get_node("AudioStreamPlayer").pitch_scale = 0.8 + randf() * 0.4
		get_node("AudioStreamPlayer").play()

# Called when the animation has finished.
func finished(e):
	queue_free()
