extends AudioStreamPlayer


@export var starting_song = false

var song_change_speed = 500

@export var ID : String = "Area1"

@export var manager : Node = null

@export var player : Player = null

func _ready():
	add_to_group("music")
	if starting_song:
		manager.current_song_playing = self
		play()

func _process(delta):
	if manager.current_song_playing == self:
		volume_db = move_toward(volume_db, 0, song_change_speed * delta)
		if not playing and player.is_on_floor():
			play()
	else:
		volume_db = move_toward(volume_db, -80, song_change_speed * delta)
