extends Area2D

var first_interaction = true

var times_died = 0

@onready var voice_player : AnimationPlayer = $VoicePlayer

var player_in_area : Player = null

var completed_wavedash_tutorial = false

var ahead_of_tutorial = false

func _ready():
	EventBus.player_respawn.connect(request_death_voice)

func _process(_delta):
	for body in get_overlapping_bodies():
		if first_interaction:
			first_interaction = false
			voice_player.play("voice_1")


func request_death_voice():

	if player_in_area:
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
