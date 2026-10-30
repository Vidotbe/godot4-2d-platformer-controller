extends Node2D

@onready var fur : Sprite2D = $Fur
@onready var eyes : Sprite2D = $Eyes
@onready var explosion : AnimatedSprite2D = $Explode
@onready var sfx : AudioStreamPlayer = $Sfx

@export var life_number = 1

var exploded_already = false

# Called when the node enters the scene tree for the first time.
func _ready():
	fur.modulate = PlayerData.fur_color
	eyes.modulate = PlayerData.eye_color
	EventBus.check_lives.connect(check_life_count)
	EventBus.start_challenge.connect(reset_life_status)
	add_to_group("challenge_life")

func reset_life_status():
	exploded_already = false
	fur.show()
	eyes.show()

func check_life_count():
	if PlayerData.challenge_lives < life_number and not exploded_already:
		exploded_already = true
		explosion.play("default")
		sfx.play()
		fur.hide()
		eyes.hide()
