extends Area2D

@export var player : Player

@export_category("NPC Look")
@export var bunny_type : Texture2D = null
@export_enum("Left", "Right") var facing_direction : String = "Left"

@export_category("Voice")
@export var soundbite : AudioStream = null

var times_interacted_with = 0
var dialogue_active = false
var in_talking_range = false

@export_category("Dialogue Order")
@export var dialogue_0 : Array = [
	"Hey, have you tried the closet? i used to be a dumb boring nobody.",
	"Now look at me! Am I NOT the coolest?"
]

@export var dialogue_1 : Array = [
	"You gotta try it if you haven't, dude."
]

@export var dialogue_2 : Array = [
]

@export var dialogue_3 : Array = [
]

@export var dialogue_4 : Array = [
]

@export var dialogue_5 : Array = [
]


var dialogue_index = 0

var next_letter_enabled = true

var speech_speed = 1

var speech_timer = 0.0

var next_letter_timer = 0.0

var next_letter_speed = 0.02


@export_category("Dialogue Box Offsets")
@export var box_y : int = 0
@export var box_x : int = 0
@export var prompt_y : int = 0
@export var prompt_x : int = 0


@onready var bunny_sprite : Sprite2D = $Bunny
@onready var dialogue_box : NinePatchRect = $NinePatchRect
@onready var dialogue : Label = $NinePatchRect/Dialogue
@onready var dialogue_prompt : Sprite2D = $Prompt
@onready var soundbite_sfx : AudioStreamPlayer2D = $SoundBite
@onready var dialogue_range : CollisionShape2D = $CollisionShape2D


func _ready():
	if bunny_type:
		bunny_sprite.texture = bunny_type

	if facing_direction == "Left":
		bunny_sprite.flip_h = true
		dialogue_range.position.x = -17
		dialogue_box.position.x = -122
		dialogue_prompt.position.x = -20

	else:
		bunny_sprite.flip_h = false
		dialogue_range.position.x = 17
		dialogue_box.position.x = 2
		dialogue_prompt.position.x = 20


	if soundbite:
		soundbite_sfx.stream = soundbite

	dialogue_prompt.position.x += prompt_x
	dialogue_prompt.position.y -= prompt_y
	dialogue_box.position.x += box_x
	dialogue_box.position.y -= box_y

func _process(delta):
	if in_talking_range and not dialogue_active:
		if Input.is_action_just_pressed("next") and player.is_on_floor():
			trigger_dialogue()
			EventBus.dialogue_started.emit()
			player_facing()
			return

	if dialogue_active:
		if Input.is_action_just_pressed("next"):
			if dialogue.visible_ratio < 1:
				dialogue.visible_ratio = 1
				return
			elif dialogue.visible_ratio >= 1:
				trigger_dialogue()
				return

		if dialogue.visible_characters != -1 and next_letter_enabled:
			if dialogue.visible_ratio >= 1:
				dialogue.visible_ratio = 1
				return
			dialogue.visible_characters += speech_speed
			play_letter_bite()
			next_letter_timer = 0.0
			next_letter_enabled = false
			var current_char = dialogue.text[dialogue.visible_characters -1]

			match current_char:
				"?", "!", ".", ",":
					next_letter_timer -= 0.2

		if not next_letter_enabled:
			next_letter_timer += delta
			if next_letter_timer >= next_letter_speed:
				next_letter_enabled = true

func player_facing():
	if facing_direction == "Left":
		player.move_direction = 1
	else:
		player.move_direction = -1


func play_letter_bite():
	var current_char = dialogue.text[dialogue.visible_characters -1]
	match current_char:
		"?", "!", ".", ",":
			return
	var pitch_randomize = randf_range(0.9,1.1)
	soundbite_sfx.pitch_scale = pitch_randomize
	soundbite_sfx.play()

func next_line_callable(lines : Array):
	var item = lines[dialogue_index]
	
	if item is Callable:
		item.call()
		return true
	else:
		return false

func trigger_dialogue():
	var get_dialogue = "dialogue_" + str(times_interacted_with)
	var get_next_dialogue = "dialogue_" + str(times_interacted_with + 1)

	var current_dialogue = get(get_dialogue)
	var next_dialogue = get(get_next_dialogue)

	speech_timer = 0.0
	dialogue.visible_characters = 0
	if dialogue_index < current_dialogue.size():
		dialogue.visible_characters = 0
		dialogue_active = true
		dialogue_box.show()
		dialogue_prompt.hide()
		if next_line_callable(current_dialogue):
			dialogue_index += 1
			return
		dialogue.text = str(current_dialogue[dialogue_index])
	else:
		dialogue_index = 0
		dialogue_active = false
		dialogue_box.hide()
		dialogue_prompt.show()
		if next_dialogue != null:
			times_interacted_with += 1
			if next_dialogue.is_empty():
				times_interacted_with -= 1
		EventBus.dialogue_over.emit()
		return
	dialogue_index += 1

func _on_body_entered(_body):
	dialogue_prompt.show()
	in_talking_range = true


func _on_body_exited(_body):
	dialogue_prompt.hide()
	in_talking_range = false
