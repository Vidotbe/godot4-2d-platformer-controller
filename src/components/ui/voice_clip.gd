extends AudioStreamPlayer2D

@export_category("Voice Organization")
@export var subtitle_dialog : Array = [
"",
"Alright so you're gonna wanna jump up", 
"and you're gonna wanna airdash, diagonally forward", 
"down", 
"and slide",
"basically, land with a slide",
"while airdashing towards the ground.",
""]

var subtitle_index = 0

@export var voice_ID : String = "voice_1"

@export var voice_player : AnimationPlayer = null
@export var subtitle_label : Label = null

@export var voice_to_test = false

func _ready():
	if voice_to_test:
		voice_player.play(voice_ID)

func update_dialog():
	var current_subtitle = subtitle_dialog[subtitle_index]
	
	subtitle_label.text = str(current_subtitle)

	subtitle_index += 1
