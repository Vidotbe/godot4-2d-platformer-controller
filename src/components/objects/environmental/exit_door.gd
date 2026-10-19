extends Area2D

@export var open = false

@onready var door_sprite : Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.on_all_diamonds.connect(open_door)

func open_door():
	open = true
	door_sprite.frame = 1

func _on_body_entered(_body):
	if open:
		print("play ending")
