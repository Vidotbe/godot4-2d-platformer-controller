extends Area2D

@export var manager : Node = null
@export var ID : String = "Area1"
# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(on_body_entered)

func on_body_entered(_body):
	manager.set_song_to(ID)
