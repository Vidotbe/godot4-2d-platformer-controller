extends Node

var current_song_playing = null
@onready var challenge_music : AudioStreamPlayer = $Challenge


func _ready():
	EventBus.diamond_key_get.connect(start_challenge_music)
	EventBus.start_challenge.connect(stop_challenge_music)


func set_song_to(ID : String):
	if not PlayerData.in_challenge:
		for song in get_tree().get_nodes_in_group("music"):
			if song.ID == ID:
				current_song_playing = song
	else:
		current_song_playing = null


func start_challenge_music():
	challenge_music.play()

func stop_challenge_music():
	challenge_music.stop()
