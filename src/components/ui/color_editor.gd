extends CanvasLayer

var active = false

@export var currently_active : Button = null
@onready var fur_colors : Control = $FurColors
@onready var eye_colors : Control = $EyeColors
@onready var glove_colors : Control = $GloveColors
@onready var boot_colors : Control = $BootColors

@onready var category_name : Label = $Label

@onready var eye_button : Button = $EyeColorButton
@onready var fur_button : Button = $FurColorButton
@onready var glove_button : Button = $GloveColorButton
@onready var boot_button : Button = $BootColorButton

@onready var category_sfx : AudioStreamPlayer = $CategorySound


@export var player : Player = null

var selected_color : Button = null
var selected_eye_color : Button = null
var selected_glove_color : Button = null
var selected_boot_color : Button = null


var editor_speed_right : float = 15.0
var editor_speed_left = 1500

# Called when the node enters the scene tree for the first time.
func _ready():
	update_ui()
	

func update_ui():
	if currently_active == fur_button:
		fur_colors.show()
		eye_colors.hide()
		glove_colors.hide()
		boot_colors.hide()
		fur_button.button_pressed = true
		eye_button.button_pressed = false
		glove_button.button_pressed = false
		boot_button.button_pressed = false
		category_name.text = "Fur"

	elif currently_active == eye_button:
		fur_colors.hide()
		eye_colors.show()
		glove_colors.hide()
		boot_colors.hide()
		fur_button.button_pressed = false
		eye_button.button_pressed = true
		glove_button.button_pressed = false
		boot_button.button_pressed = false
		category_name.text = "Eyes"
	
	elif currently_active == glove_button:
		fur_colors.hide()
		eye_colors.hide()
		glove_colors.show()
		boot_colors.hide()
		fur_button.button_pressed = false
		eye_button.button_pressed = false
		glove_button.button_pressed = true
		boot_button.button_pressed = false
		category_name.text = "Gloves"

	elif currently_active == boot_button:
		fur_colors.hide()
		eye_colors.hide()
		glove_colors.hide()
		boot_colors.show()
		fur_button.button_pressed = false
		eye_button.button_pressed = false
		glove_button.button_pressed = false
		boot_button.button_pressed = true
		category_name.text = "Boots"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active:
		offset.x = lerp(offset.x, 0.0, editor_speed_right * delta)
		if abs(offset.x) < 0.5:
			offset.x = 0
	else:
		offset.x = move_toward(offset.x, -110, editor_speed_left * delta)


func _on_fur_color_button_pressed():
	if currently_active != fur_button:
		category_sfx.play()
		currently_active = fur_button
		update_ui()
	else:
		fur_button.button_pressed = true

func _on_eye_color_button_pressed():
	if currently_active != eye_button:
		category_sfx.play()
		currently_active = eye_button
		update_ui()
	else:
		eye_button.button_pressed = true

func _on_glove_color_button_pressed():
	if currently_active != glove_button:
		category_sfx.play()
		currently_active = glove_button
		update_ui()
	else:
		glove_button.button_pressed = true

func _on_boot_color_button_pressed():
	if currently_active != boot_button:
		category_sfx.play()
		currently_active = boot_button
		update_ui()
	else:
		boot_button.button_pressed = true
