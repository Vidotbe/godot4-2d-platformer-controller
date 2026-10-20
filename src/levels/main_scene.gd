extends Node2D

@onready var player : Player = $Player
@onready var patch : TileMapLayer = $TileMapLayer2
@onready var background : Sprite2D = $Background/ParallaxLayer/TextureRect
@onready var black_background : ColorRect = $Background/ColorRect

@onready var weird_sign : Area2D = $Signs/Sign11

@onready var level_reveal : CanvasLayer = $LevelReveal
var reveal_speed = 1000

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.reset_awareness.connect(restore)

	if PlayerData.sandbox_mode:
		patch.enabled = true
	else:
		if PlayerData.player_has_wand:
			patch.enabled = true

func _process(delta):
	if player.global_position.y < -2300 and player.global_position.x < 0:
		player.camera.limit_left = -4152

	if player.global_position.y > -2300 and player.global_position.x < 0:
		player.camera.limit_left = -3207


	if level_reveal.offset.y >= -800:
		level_reveal.offset.y = move_toward(level_reveal.offset.y, -800, reveal_speed * delta)
	if level_reveal.offset.y == -800:
		level_reveal.hide()

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
