extends Node2D

var camera_speed = 1200

@onready var description = $DescriptionLabel

var selected_mode : String = "null"

@onready var adventure_card : Button = $AdventureButton
@onready var sandbox_card : Button = $SandboxButton

@onready var animation_player : AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	var base_size = Vector2i(480, 270)
	var scale_factor = 3

	var window_size = base_size * scale_factor
	
	DisplayServer.window_set_size(window_size)

	var screen_center := DisplayServer.screen_get_position() + (DisplayServer.screen_get_size() / 2)
	DisplayServer.window_set_position(screen_center - (window_size / 2))



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if selected_mode != "null":
		adventure_card.global_position.y -= camera_speed * delta
		sandbox_card.global_position.y -= camera_speed * delta

func _on_adventure_button_mouse_entered():
	if selected_mode == "null":
		description.text = "Explore the world and climb your way up to 50 Diamonds."


func _on_adventure_button_mouse_exited():
	if selected_mode == "null":
		description.text = "Please select your experience"


func _on_sandbox_button_mouse_entered():
	if selected_mode == "null":
		description.text = "Infinite possibilities, the sky is the limit."


func _on_sandbox_button_mouse_exited():
	if selected_mode == "null":
		description.text = "Please select your experience"


func _on_adventure_button_pressed():
	if selected_mode == "null":
		selected_mode = "Adventure"
		PlayerData.sandbox_mode = false
		animation_player.play("start")
		description.text = "Please select your experience"


func _on_sandbox_button_pressed():
	if selected_mode == "null":
		selected_mode = "Sandbox"
		PlayerData.sandbox_mode = true
		animation_player.play("start")
		description.text = "Please select your experience"


func _on_animation_player_animation_finished(_start):
	get_tree().change_scene_to_file("res://src/levels/main_scene.tscn")
