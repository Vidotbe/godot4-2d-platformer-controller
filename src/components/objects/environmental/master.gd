extends Node2D

@onready var animation_player : AnimationPlayer = $AnimationPlayer

@export var speech : Label = null

var speech_lines : Array = [
	"So you've come.",
	"I've been watching you.",
	"And you certainly surpass your...",
	"Predecessor.",
	"  ",
	"How about one last challenge?",
	took_wand(),
	took_wand_two(),
	"Now.",
	"Why not send you even further down?",
	"Let's have some fun, little bunny."
]

var post_game_lines : Array = [
	"So you're here again.",
	"I wonder why, little bunny.",
	"There's nothing new for you here.",
	"Is the glory not enough? Is the risk amusing to you?",
	"Novelty must not be what you seek.",
	"Even when I can't see, It's clear to bestow...",
	"That your colleagues must grow jealous.",
	"Yet I grow curious.",
	"How about the same game? I deem it agreeable.",
	"It is fun to watch you, little bunny."
]

var no_death_lines : Array = [
	"I finally meet you.",
	"You are different, little bunny.",
	"No other has come before you, and many have perished.",
	"Whether you had this with you or not...",
	"Your courage has far exceeded my ability to behold.",
	"This last challenge awaits you, and I can't wait for you.",
	"Will you impress me once more?",
	"Will you fall and be one more with the rest of rabbits?",
	"I am in deep observation for the outcome...",
	"Chosen One.",
	"Please, do show me your resolve one more time."
]

var revealed = false

var speech_index = 0

var can_pass_dialogue = false

var next_letter_enabled = true

var speech_speed = 1

var speech_timer = 0.0

var speech_time_to_read = 3.0

var next_letter_timer = 0.0

var next_letter_speed = 0.06

var dialogue : String = "null"

@onready var letter_manager : AudioStreamPlayer = $LetterManager

func _ready():
	speech.visible_characters = 0


func took_wand():
	if PlayerData.player_has_wand:
		dialogue = "Looking for this?"
	else:
		dialogue = "Interesting you don't have this on you."
	return dialogue


func took_wand_two():
	if PlayerData.player_has_wand:
		dialogue = "You're not going anywhere, if not by my hand."
	else:
		dialogue = "Did you lose it, or did someone take it?"
	return dialogue

func _process(delta):
	
	if Input.is_action_just_pressed("next") and can_pass_dialogue:
		if speech.visible_ratio < 1:
			speech.visible_ratio = 1
			return
		elif speech.visible_ratio >= 1:
			trigger_dialogue()
			return

	if speech.visible_ratio == 1 and can_pass_dialogue:
		speech_timer += delta

		if speech_timer >= speech_time_to_read:
			trigger_dialogue()

	if speech.visible_characters != -1 and can_pass_dialogue and next_letter_enabled:
		if speech.visible_ratio >= 1:
			speech.visible_ratio = 1
			return
		speech.visible_characters += speech_speed
		play_letter_bite()
		next_letter_timer = 0.0
		next_letter_enabled = false
		var current_char = speech.text[speech.visible_characters -1]

		match current_char:
			",":
				next_letter_timer -= 1.0
			"?":
				next_letter_timer -= 1.0

	if not next_letter_enabled:
		next_letter_timer += delta
		if next_letter_timer >= next_letter_speed:
			next_letter_enabled = true


func play_letter_bite():
	var current_char = speech.text[speech.visible_characters -1]
	var current_letter = current_char.to_upper()

	for child in letter_manager.get_children():
		if child is AudioStreamPlayer:
			if child.playing:
				child.stop()

	if letter_manager.has_node(current_letter):
		letter_manager.get_node(current_letter).play()
	else:
		pass

func trigger_dialogue():
	if PlayerData.times_died == 0:
		speech_timer = 0.0
		speech.visible_characters = 0
		if speech_index < no_death_lines.size():
			speech.visible_characters = 0
			speech.text = str(no_death_lines[speech_index])
		else:
			can_pass_dialogue = false
			EventBus.emit_signal("start_challenge")
		speech_index += 1
		return

	if PlayerData.adventure_mode_complete:
		speech_timer = 0.0
		speech.visible_characters = 0
		if speech_index < post_game_lines.size():
			speech.visible_characters = 0
			speech.text = str(post_game_lines[speech_index])
		else:
			can_pass_dialogue = false
			EventBus.emit_signal("start_challenge")
		speech_index += 1
	else:
		speech_timer = 0.0
		speech.visible_characters = 0
		if speech_index < speech_lines.size():
			speech.visible_characters = 0
			speech.text = str(speech_lines[speech_index])
		else:
			can_pass_dialogue = false
			EventBus.emit_signal("start_challenge")
		speech_index += 1

func _on_entrance_event_body_entered(_body):
	if not revealed:
		animation_player.play("appear")
		revealed = true
		PlayerData.in_challenge = true

func _on_animation_player_animation_finished(_appear):
	can_pass_dialogue = true
	trigger_dialogue()
