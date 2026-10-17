extends Node2D

@onready var player : Player = $Player
@onready var patch : TileMapLayer = $TileMapLayer2
@onready var background : Sprite2D = $Background/ParallaxLayer/TextureRect
@onready var black_background : ColorRect = $Background/ColorRect

@onready var weird_sign : Area2D = $Signs/Sign11

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.reset_awareness.connect(restore)


func restore():
	background.show()
	weird_sign.sign_information = "You can use Space to Jump!"
	weird_sign.weird = true

func _on_hidden_body_entered(_body):
	player.player_eyes.hide()
	background.hide()
	black_background.show()
	patch.enabled = true
	player.camera.limit_left = 2900
	player.camera.limit_right = 5056
