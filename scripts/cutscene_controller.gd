extends Node

# The different cutscenes.
enum CUTSCENE { INTRO, FORESIGHT, HIT_THE_ORB, FIRST_HIT, ENDING }

var has_played = []

onready var message_box = get_node("../MessageBox")

# Called when the node enters the scene tree for the first time.
func _ready():
	has_played.resize(CUTSCENE.size())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Play the intro on the first frame.
	play_cutscene(CUTSCENE.INTRO, "intro_messages_done")
	
	if Global.has_stopped_orb:
		play_cutscene(CUTSCENE.HIT_THE_ORB, "do_nothing")
	
	if Global.has_hit_boss:
		play_cutscene(CUTSCENE.FIRST_HIT, "do_nothing")

# Play a cutscene, but only if it hasn't been played before.
func play_cutscene(cutscene, otherwise):
	if !Global.has_played_cutscene.has(cutscene):
		play_cutscene_regardless(cutscene)
	elif !has_played[cutscene]:
		has_played[cutscene] = true
		call(otherwise)

# Play a cutscene, regardless of whether it has been played before.
func play_cutscene_regardless(cutscene):
	if !has_played[cutscene]:
		if cutscene == CUTSCENE.INTRO:
			intro()
		elif cutscene == CUTSCENE.FORESIGHT:
			foresight()
		elif cutscene == CUTSCENE.HIT_THE_ORB:
			hit_the_orb()
		elif cutscene == CUTSCENE.FIRST_HIT:
			first_hit()
		elif cutscene == CUTSCENE.ENDING:
			ending()
		has_played[cutscene] = true
		Global.has_played_cutscene[cutscene] = true

# The intro cutscene.
func intro():
	Global.paused = true
	message_box.add_message(message_box.CAT_FACEPAW, "You've really done it this time.")
	message_box.add_message(message_box.CAT_SWEAT, "I have to admit.\nI didn't think you'd unleash a massive lich.")
	message_box.add_message(message_box.CAT_NEUTRAL, "Well... what are you waiting for?")
	message_box.add_message(message_box.CAT_SHOW_TEETH, "Let's kick some lich butt!")
	message_box.show_messages(self, "intro_messages_done")

func intro_messages_done():
	play_cutscene(CUTSCENE.FORESIGHT, "foresight_messages_done")

# Tutorial explaining foresight.
func foresight():
	message_box.add_message(message_box.CAT_SHOW_TEETH, "Watch out! It's about to attack!")
	message_box.add_message(message_box.CAT_SHOW_TEETH, "Use your foresight to determine the path of the orb!")
	message_box.show_messages(self, "foresight_messages_done")

func foresight_messages_done():
	Global.paused = false
	get_node("../boss").fire()

# Tutorial explaining how to hit the orb.
func hit_the_orb():
	Global.paused = true
	message_box.add_message(message_box.CAT_NEUTRAL, "Hey. I'm not toast!\nWell dodged.")
	message_box.add_message(message_box.CAT_FACEPAW, "I wish you would have used your foresight\nbefore you broke into professor...")
	message_box.add_message(message_box.CAT_FACEPAW, "... Fairbank's office and unleashed a hell lich.")
	message_box.show_messages(self, "hit_the_orb_messages_done")

func hit_the_orb_messages_done():
	message_box.add_message(message_box.CAT_NEUTRAL, "Did you see that?")
	message_box.add_message(message_box.CAT_NEUTRAL, "The orb just changed color!")
	message_box.add_message(message_box.CAT_SHOW_TEETH, "I think it's time to use this lich's orb\nagainst it!")
	message_box.show_messages(self, "hit_the_orb_messages2_done")

func hit_the_orb_messages2_done():
	Global.paused = false

# Tutorial explaining that you did damage.
func first_hit():
	Global.paused = true

# The ending cutscene.
func ending():
	Global.paused = true

# ¯\_(ツ)_/¯
func do_nothing():
	pass
