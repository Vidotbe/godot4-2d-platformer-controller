extends Node2D

@export var player : Player = null

var challenge_type : Array[Dictionary] = [
	{
		"name": "Jump1",
		"camera_limit_left": -2712,
		"camera_limit_right": -2152,
		"camera_limit_top": 847,
		"camera_limit_bottom": 1336,
		"target_location": Vector2(-2440,1271),
		"prompt": "Jump!"
	},
	{
		"name": "Run1",
		"camera_limit_left": -1840,
		"camera_limit_right": -1368,
		"camera_limit_top": 664,
		"camera_limit_bottom": 1368,
		"target_location": Vector2(-1704,816),
		"prompt": "Run!"
	}
]

var challenge_end : Array[Dictionary] = [
	{
		"name": "End",
		"camera_limit_left": 48,
		"camera_limit_right": 497,
		"camera_limit_top": 60,
		"camera_limit_bottom": 1641,
		"target_location": Vector2(271,1536),
		"prompt": "Get out!"
	}
]

var current_challenge : Dictionary = {}

@onready var backup_challenges = challenge_type.duplicate(true)

@onready var prompt : Label = $CanvasLayer/Prompt
var prompt_timer : float = 0.0
var prompt_time_limit : float = 2.0

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.start_challenge.connect(reset_challenges)
	EventBus.diamond_key_get.connect(next_challenge)
	EventBus.next_challenge.connect(next_challenge)

func reset_challenges():
	challenge_type = backup_challenges.duplicate(true)

func next_challenge():
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

		player.camera.limit_left = limit_left
		player.camera.limit_right = limit_right
		player.camera.limit_top = limit_top
		player.camera.limit_bottom = limit_bottom

		var prompt_text = current_challenge["prompt"] #A WHITE TEXT POPUP APPEARS THAT TELLS YOU WHAT TO DO. LIKE "JUMP!" FOR EXAMPLE

		prompt.text = prompt_text

		challenge_type.erase(current_challenge) #REMOVES THIS CHALLENGE FROM THE LIST, SO NEXT TIME THIS GETS CALLED, IT WILL CALL A NEW ONE

func end_challenge():
	var data = challenge_end[0]

	var destination = data["target_location"] #TELLS THE PLAYER WHERE THE CHALLENGE IS LOCATED
	player.hide()
	player.start_fast_travel(destination)

	var limit_left = data["camera_limit_left"] #THIS SETS UP THE CAMERA BOUNDARIES SO IT LOOKS LIKE AN ENCLOSED SPACE
	var limit_right = data["camera_limit_right"]
	var limit_top = data["camera_limit_top"]
	var limit_bottom = data["camera_limit_bottom"]

	player.camera.limit_left = limit_left
	player.camera.limit_right = limit_right
	player.camera.limit_top = limit_top
	player.camera.limit_bottom = limit_bottom

	var prompt_text = data["prompt"] #A WHITE TEXT POPUP APPEARS THAT TELLS YOU WHAT TO DO. LIKE "JUMP!" FOR EXAMPLE

	prompt.text = prompt_text


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if prompt.text != "":
		prompt_timer += delta
		if prompt_timer >= prompt_time_limit:
			prompt_timer = 0.0
			prompt.text = ""
