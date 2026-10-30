extends Node2D

@export var player : Player = null

@onready var end_patch : TileMapLayer = $Patch

var challenge_type : Array[Dictionary] = [
	{
		"name": "Jump1",
		"camera_limit_left": -2631,
		"camera_limit_right": -2152,
		"camera_limit_top": 847,
		"camera_limit_bottom": 1336,
		"target_location": Vector2(-2440,1271),
		"prompt": " JUMP!"
	},
	{
		"name": "Run1",
		"camera_limit_left": -1840,
		"camera_limit_right": -1368,
		"camera_limit_top": 664,
		"camera_limit_bottom": 1368,
		"target_location": Vector2(-1704,816),
		"prompt": " RUN!"
	},
	{
		"name": "DoubleJump1",
		"camera_limit_left": -1160,
		"camera_limit_right": -680,
		"camera_limit_top": 672,
		"camera_limit_bottom": 942,
		"target_location": Vector2(-920,741),
		"prompt": " DOUBLE JUMP!"
	},
	{
		"name": "WallSlide1",
		"camera_limit_left": -1160,
		"camera_limit_right": -680,
		"camera_limit_top": 1136,
		"camera_limit_bottom": 1737,
		"target_location": Vector2(-920,1696),
		"prompt": " WALL SLIDE!"
	},
	{
		"name": "Slide1",
		"camera_limit_left": -2688,
		"camera_limit_right": -1784,
		"camera_limit_top": 248,
		"camera_limit_bottom": 518,
		"target_location": Vector2(-2608,376),
		"prompt": " SLIDE!"
	},
	{
		"name": "SlowFall1",
		"camera_limit_left": -1752,
		"camera_limit_right": -1112,
		"camera_limit_top": 248,
		"camera_limit_bottom": 518,
		"target_location": Vector2(-1656,440),
		"prompt": " SLOW FALL!"
	},
	{
		"name": "Jump2",
		"camera_limit_left": -656,
		"camera_limit_right": -176,
		"camera_limit_top": 1136,
		"camera_limit_bottom": 1737,
		"target_location": Vector2(-416,1696),
		"prompt": " MOON JUMP!"
	},
	{
		"name": "AirDash1",
		"camera_limit_left": -656,
		"camera_limit_right": -176,
		"camera_limit_top": 672,
		"camera_limit_bottom": 942,
		"target_location": Vector2(-592,856),
		"prompt": " AIR DASH!"
	},
	{
		"name": "WallJump1",
		"camera_limit_left": -656,
		"camera_limit_right": -176,
		"camera_limit_top": 360,
		"camera_limit_bottom": 630,
		"target_location": Vector2(-592,456),
		"prompt": " WALL JUMP!"
	},
	{
		"name": "Jump3",
		"camera_limit_left": -3248,
		"camera_limit_right": -2768,
		"camera_limit_top": 664,
		"camera_limit_bottom": 1368,
		"target_location": Vector2(-3008,1232),
		"prompt": " JUMP!"
	},
	{
		"name": "WaveDash1",
		"camera_limit_left": -3624,
		"camera_limit_right": -2720,
		"camera_limit_top": 248,
		"camera_limit_bottom": 518,
		"target_location": Vector2(-3528,448),
		"prompt": " WAVEDASH!"
	},
	{
		"name": "DoubleJump2",
		"camera_limit_left": -1160,
		"camera_limit_right": -680,
		"camera_limit_top": 1800,
		"camera_limit_bottom": 2097,
		"target_location": Vector2(-920,1880),
		"prompt": " DOUBLE JUMP!"
	},
	{
		"name": "WallJump2",
		"camera_limit_left": -2712,
		"camera_limit_right": -2152,
		"camera_limit_top": 2120,
		"camera_limit_bottom": 2600,
		"target_location": Vector2(-2248,2520),
		"prompt": " WALL JUMP!"
	}
]

var challenge_end : Array[Dictionary] = [
	{
		"name": "End",
		"camera_limit_left": 48,
		"camera_limit_right": 497,
		"camera_limit_top": -270,
		"camera_limit_bottom": 1641,
		"target_location": Vector2(271,1536),
		"prompt": " GET OUT!"
	}
]

var current_challenge : Dictionary = {}

@onready var backup_challenges = challenge_type.duplicate(true)

@onready var prompt : Label = $CanvasLayer/Prompt
var prompt_timer : float = 0.0
var prompt_time_limit : float = 2.0


func _ready():
	EventBus.start_challenge.connect(reset_challenges)
	EventBus.diamond_key_get.connect(next_challenge)
	EventBus.next_challenge.connect(next_challenge)
	EventBus.next_challenge_fail.connect(next_challenge_life_lost)
	EventBus.display_prompt.connect(display_prompt)


func reset_challenges():
	challenge_type = backup_challenges.duplicate(true)
	end_patch.enabled = true
	PlayerData.challenge_lives = 4
	prompt_timer = 0.0
	prompt.text = ""

func display_prompt():
	var prompt_text = current_challenge["prompt"]
	prompt_timer = 0.0
	if PlayerData.challenge_lives == 0:
		prompt.text = " TRY AGAIN!"
		return
	if challenge_type.is_empty():
		prompt.text = "GET OUT!"
		return
	prompt.text = prompt_text

func next_challenge():
	challenge_type.erase(current_challenge)

	if challenge_type.is_empty(): #FIRST WE MAKE SURE THAT THERE EVEN IS CHALLENGES LEFT TO COMPLETE
		end_challenge()
		return

	else:
		
		current_challenge = challenge_type.pick_random() #PICKS A RANDOM ONE FROM THE LIST
		
		var destination = current_challenge["target_location"] #TELLS THE PLAYER WHERE THE CHALLENGE IS LOCATED
		player.hide()
		player.start_fast_travel(destination)

		var limit_left = current_challenge["camera_limit_left"] #THIS SETS UP THE CAMERA BOUNDARIES SO IT LOOKS LIKE AN ENCLOSED SPACE
		var limit_right = current_challenge["camera_limit_right"]
		var limit_top = current_challenge["camera_limit_top"]
		var limit_bottom = current_challenge["camera_limit_bottom"]

		await get_tree().create_timer(3,false).timeout

		player.camera.limit_left = limit_left
		player.camera.limit_right = limit_right
		player.camera.limit_top = limit_top
		player.camera.limit_bottom = limit_bottom



func next_challenge_life_lost():
	EventBus.emit_signal("intermission_fail")
	if challenge_type.is_empty(): #FIRST WE MAKE SURE THAT THERE EVEN IS CHALLENGES LEFT TO COMPLETE
		end_challenge()

	else:
		current_challenge = challenge_type.pick_random() #PICKS A RANDOM ONE FROM THE LIST
		
		var destination = current_challenge["target_location"] #TELLS THE PLAYER WHERE THE CHALLENGE IS LOCATED
		player.hide()
		player.start_fast_travel(destination)

		var limit_left = current_challenge["camera_limit_left"] #THIS SETS UP THE CAMERA BOUNDARIES SO IT LOOKS LIKE AN ENCLOSED SPACE
		var limit_right = current_challenge["camera_limit_right"]
		var limit_top = current_challenge["camera_limit_top"]
		var limit_bottom = current_challenge["camera_limit_bottom"]

		await get_tree().create_timer(3,false).timeout

		player.camera.limit_left = limit_left
		player.camera.limit_right = limit_right
		player.camera.limit_top = limit_top
		player.camera.limit_bottom = limit_bottom


func end_challenge():
	var data = challenge_end[0]

	var destination = data["target_location"] #TELLS THE PLAYER WHERE THE CHALLENGE IS LOCATED
	player.hide()
	player.start_fast_travel(destination)

	var limit_left = data["camera_limit_left"] #THIS SETS UP THE CAMERA BOUNDARIES SO IT LOOKS LIKE AN ENCLOSED SPACE
	var limit_right = data["camera_limit_right"]
	var limit_top = data["camera_limit_top"]
	var limit_bottom = data["camera_limit_bottom"]

	await get_tree().create_timer(3,false).timeout

	player.camera.limit_left = limit_left
	player.camera.limit_right = limit_right
	player.camera.limit_top = limit_top
	player.camera.limit_bottom = limit_bottom

	end_patch.enabled = false


func _process(delta):
	if prompt.text != "":
		prompt_timer += delta
		if prompt_timer >= prompt_time_limit:
			prompt_timer = 0.0
			prompt.text = ""
