extends Button

@export var player : Player = null
@export var default_color = false
@export var editor : CanvasLayer = null
@export var type : String = ""


func _ready():
	if type == "Fur":
		if default_color:
			editor.selected_color = self
			button_pressed = true

	if type == "Eye":
		add_to_group("eye_color_button")
		if default_color:
			editor.selected_eye_color = self
			button_pressed = true

	if type == "Glove":
		add_to_group("glove_color_button")
		if default_color:
			editor.selected_glove_color = self
			button_pressed = true

	if type == "Boot":
		add_to_group("boot_color_button")
		if default_color:
			editor.selected_boot_color = self
			button_pressed = true

func update_selection():
	if type == "Fur":
		var buttons = get_tree().get_nodes_in_group("fur_color_button")
		
		for button in buttons:
			if editor.selected_color == button:
				button.button_pressed = true
			else:
				button.button_pressed = false

	if type == "Eye":
		var buttons = get_tree().get_nodes_in_group("eye_color_button")
		
		for button in buttons:
			if editor.selected_eye_color == button:
				button.button_pressed = true
			else:
				button.button_pressed = false

	if type == "Glove":
		var buttons = get_tree().get_nodes_in_group("glove_color_button")
		
		for button in buttons:
			if editor.selected_glove_color == button:
				button.button_pressed = true
			else:
				button.button_pressed = false

	if type == "Boot":
		var buttons = get_tree().get_nodes_in_group("boot_color_button")
		
		for button in buttons:
			if editor.selected_boot_color == button:
				button.button_pressed = true
			else:
				button.button_pressed = false


func _on_pressed():
	if type == "Fur":
		player.player_fur.modulate = modulate
		editor.selected_color = self
	if type == "Eye":
		player.player_eyes.modulate = modulate
		editor.selected_eye_color = self
	if type == "Glove":
		player.player_gloves.modulate = modulate
		editor.selected_glove_color = self
	if type == "Boot":
		player.player_boots.modulate = modulate
		editor.selected_boot_color = self

	update_selection()
