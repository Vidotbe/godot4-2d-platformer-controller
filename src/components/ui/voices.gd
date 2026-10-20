extends Area2D

var first_interaction = true

var times_died = 0

@onready var voice_player : AnimationPlayer = $VoicePlayer

var player_in_area : Player = null

var completed_wavedash_tutorial = false

var activated = false

@onready var voice_block_body : StaticBody2D = $VoiceBlock
@onready var voice_block : Sprite2D = $VoiceBlock/Sprite2D

@export var subtitle_label : Label = null

func _ready():
	EventBus.player_respawn.connect(request_death_voice)

func _process(delta):
	for body in get_overlapping_bodies():
		if first_interaction and activated:
			first_interaction = false
			voice_player.play("voice_1")

	if voice_block_body.global_position.y != -2370:
		voice_block_body.global_position.y = move_toward(voice_block_body.global_position.y, -2370, 400 * delta)


func request_death_voice():
	if player_in_area and activated:
		for voice : AudioStreamPlayer2D in get_tree().get_nodes_in_group("voice_clips"):
			voice.playing = false
		times_died += 1
		var animation_name = "death_" + str(times_died)
		if voice_player.has_animation(animation_name):
			voice_player.play(animation_name)

func request_context_dialog(context : String = "Test"):
	if context == "wavedash_tutorial_complete":
		completed_wavedash_tutorial = true
	voice_player.play(context)



func _on_body_entered(body):
	player_in_area = body


func _on_body_exited(_body):
	player_in_area = null


func _on_voice_block_body_entered(_body):
	voice_block_body.global_position.y -= 24
	if not activated:
		activated = true
		voice_block.frame = 1
	else:
		activated = false
		voice_block.frame = 0
		for voice : AudioStreamPlayer2D in get_tree().get_nodes_in_group("voice_clips"):
			voice.playing = false
		subtitle_label.text = ""
		voice_player.pause()
