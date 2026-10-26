extends Node2D

@onready var player : Player = $Player
@onready var patch : TileMapLayer = $TileMapLayer2
@onready var top_wall : TileMapLayer = $TopPatch
@onready var lair : TileMapLayer = $Lair
@onready var lair_floor : TileMapLayer = $LairFloor
@onready var background : Sprite2D = $Background/ParallaxLayer/TextureRect
@onready var black_background : ColorRect = $Background/ColorRect

@onready var weird_sign : Area2D = $Signs/Sign11

@onready var level_reveal : CanvasLayer = $LevelReveal
var reveal_speed = 1000

@onready var time_limit_graphic : Node2D = $ChallengeSection/CanvasLayer/TimeLimit
@onready var time_left_label : Label = $ChallengeSection/CanvasLayer/TimeLimit/TimeLeft
var challenge_time_limit : float = 180
var timer_started = false


# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.reset_awareness.connect(restore)
	EventBus.on_all_diamonds.connect(all_diamonds)
	EventBus.start_challenge.connect(start_challenge)
	EventBus.diamond_key_get.connect(start_timer)

	PlayerData.times_died = 0
	

	if PlayerData.sandbox_mode:
		patch.enabled = true
	else:
		if PlayerData.player_has_wand:
			patch.enabled = true
			restore()

	PlayerData.in_challenge = false

func _process(delta):
	if not PlayerData.in_challenge:
		if player.global_position.y < -2300 and player.global_position.x < 0:
			player.camera.limit_left = -4152

		if player.global_position.y > -2300 and player.global_position.x < 0:
			player.camera.limit_left = -3207


	if level_reveal.offset.y >= -800:
		level_reveal.offset.y = move_toward(level_reveal.offset.y, -800, reveal_speed * delta)
	if level_reveal.offset.y == -800:
		level_reveal.hide()

	if timer_started:
		challenge_time_limit -= delta
		
		if challenge_time_limit < 0:
			challenge_time_limit = 0
			timer_started = false
	
		@warning_ignore("integer_division")
		var minutes = int(challenge_time_limit) / 60
		var seconds = int(challenge_time_limit) % 60
		
		time_left_label.text = "%02d:%02d" % [minutes,seconds]

func restore():
	background.show()
	weird_sign.sign_information = "You can use Space to Jump!"
	weird_sign.weird = true

func all_diamonds():
	top_wall.enabled = false
	lair.enabled = true

func start_challenge():
	background.hide()
	black_background.show()

func start_timer():
	time_limit_graphic.show()
	timer_started = true

func _on_hidden_body_entered(_body):
	player.player_eyes.hide()
	background.hide()
	black_background.show()
	patch.enabled = true
	player.camera.limit_left = 2900
	player.camera.limit_right = 5056


func _on_entrance_event_body_entered(_body):
	player.camera.limit_bottom = -4136 + 270
	player.camera.limit_top = -4136
	player.camera.limit_left = 168
	player.camera.limit_right = 168 + 480
	lair_floor.enabled = true
	PlayerData.in_cutscene = true
