extends Node

var current_song_playing = null


func set_song_to(ID : String):
	for song in get_tree().get_nodes_in_group("music"):
		if song.ID == ID:
			current_song_playing = song
