extends Node2D

var camera_speed = 1400

@onready var description = $DescriptionLabel
@onready var quote = $CanvasLayer/Node2D/Label

var can_start = false
var start_pressed = false


var selected_mode : String = "null"

@onready var adventure_card : Button = $AdventureButton
@onready var sandbox_card : Button = $SandboxButton

@onready var animation_player : AnimationPlayer = $AnimationPlayer

@onready var bg_flash : AnimationPlayer = $BgFlash

@onready var pre_title_screen : CanvasLayer = $CanvasLayer

@onready var game_title : Sprite2D = $Title/Sprite2D

@onready var start_label : Label = $StartLabel

@onready var star : Sprite2D = $AdventureButton/Star

@onready var title_group : Control = $Title

@onready var fur : Sprite2D = $Title/Bunny/Fur
@onready var eyes : Sprite2D = $Title/Bunny/Eyes
@onready var gloves : Sprite2D = $Title/Bunny/Gloves
@onready var boots : Sprite2D = $Title/Bunny/Boots

@onready var start_sfx = $SoundManager/Start
@onready var start_music = $SoundManager/Music
@onready var alt_music = $SoundManager/Gone
@onready var wind = $SoundManager/Wind
@onready var button_sfx = $SoundManager/ButtonHover

var random_adventure_lines : Array = [
	"Good luck.",
	"Let's start this game, then.",
	"i promise i'll be back",
	"As you wish."
]

var random_sandbox_lines : Array = [
	"Go nuts.",
	"Ideal for testing.",
	"Sweet dreams, little bunny.",
	"You need a story?",
	"Back to bed?"
]

var random_pre_text : Array = [
	"There is no knowledge that is not power.",
	"All that glitters, is not gold.",
	"There are no accidents.",
	"No thanks, bro.",
	"What is better - to be born good, or to overcome your evil nature through Great Effort?",
	"Don't let the corruption of others be an excuse for your own."
	
]

# Called when the node enters the scene tree for the first time.
func _ready():
	var base_size = Vector2i(480, 270)
	var scale_factor = 3

	var window_size = base_size * scale_factor
	
	DisplayServer.window_set_size(window_size)

	var screen_center := DisplayServer.screen_get_position() + (DisplayServer.screen_get_size() / 2)
	DisplayServer.window_set_position(screen_center - (window_size / 2))

	quote.text = "\"" + str(random_pre_text.pick_random()) + "\""

	if PlayerData.adventure_mode_complete:
		if PlayerData.player_has_wand:
			game_title.frame = 1
			eyes.frame = 1
			star.show()
			star.modulate = Color.BLACK
		else:
			star.show()

	fur.modulate = PlayerData.fur_color
	eyes.modulate = PlayerData.eye_color
	gloves.modulate = PlayerData.gloves_color
	boots.modulate = PlayerData.boots_color


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if selected_mode != "null":
		adventure_card.global_position.y -= camera_speed * delta
		sandbox_card.global_position.y -= camera_speed * delta
		star.global_position.y -= camera_speed * delta
		return

	if Input.is_action_just_pressed("menu"):
		get_tree().quit()

	if Input.is_action_just_pressed("start") and not start_pressed and can_start:
		start_label.hide()
		start_pressed = true
		wind.stop()
		pre_title_screen.hide()
		bg_flash.play("flash")
		if PlayerData.adventure_mode_complete and PlayerData.player_has_wand:
			alt_music.play()
		else:
			start_sfx.play()
			start_music.play()

	if start_pressed and selected_mode == "null":
		title_group.position.y = lerp(title_group.position.y, 0.0, 15.0 * delta)
		if title_group.position.y < 0.5:
			title_group.position.y = 0
		await get_tree().create_timer(0.3, false).timeout
		if selected_mode == "null":
			adventure_card.position.y = lerp(adventure_card.position.y, 112.0, 15.0 * delta)
			if adventure_card.position.y < 111.5:
				adventure_card.position.y = 0

			sandbox_card.position.y = lerp(sandbox_card.position.y, 112.0, 15.0 * delta)
			if sandbox_card.position.y < 111.5:
				sandbox_card.position.y = 0

		description.show()



func _on_adventure_button_mouse_entered():
	if selected_mode == "null":
		description.text = "Explore the world and collect Diamonds to open The Gate."
		button_sfx.play()

func _on_adventure_button_mouse_exited():
	if selected_mode == "null":
		description.text = "Select Mode"


func _on_sandbox_button_mouse_entered():
	if selected_mode == "null":
		description.text = "Infinite possibilities, the sky is the limit."
		button_sfx.play()


func _on_sandbox_button_mouse_exited():
	if selected_mode == "null":
		description.text = "Select Mode"


func _on_adventure_button_pressed():
	if selected_mode == "null":
		selected_mode = "Adventure"
		PlayerData.sandbox_mode = false
		animation_player.play("start")
		start_sfx.play()
		var displayed_line = random_adventure_lines.pick_random()
		description.text = str(displayed_line)


func _on_sandbox_button_pressed():
	if selected_mode == "null":
		selected_mode = "Sandbox"
		PlayerData.sandbox_mode = true
		animation_player.play("start")
		start_sfx.play()
		var displayed_line = random_sandbox_lines.pick_random()
		description.text = str(displayed_line)


func _on_animation_player_animation_finished(_start):
	get_tree().change_scene_to_file("res://src/levels/main_scene.tscn")


func _on_my_name_animation_finished(_popup_and_fade):
	adventure_card.disabled = false
	sandbox_card.disabled = false
	can_start = true
	wind.play()
