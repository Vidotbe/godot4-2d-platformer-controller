extends Button

@export var player : Player = null
@export var default_color = false
@export var editor : CanvasLayer = null
@export var type : String = ""


func _ready():
	if type == "Fur":
		add_to_group("fur_color_button")
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
	
	await get_tree().process_frame
	update_selected_colors()


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

func update_selected_colors():
	for furbutton in get_tree().get_nodes_in_group("fur_color_button"):
		if furbutton.modulate == PlayerData.fur_color:
			editor.selected_color = furbutton
	
	for eyebutton in get_tree().get_nodes_in_group("eye_color_button"):
		if eyebutton.modulate == PlayerData.eye_color:
			editor.selected_eye_color = eyebutton
	
	for glovebutton in get_tree().get_nodes_in_group("glove_color_button"):
		if glovebutton.modulate == PlayerData.gloves_color:
			editor.selected_glove_color = glovebutton
	
	for bootbutton in get_tree().get_nodes_in_group("boot_color_button"):
		if bootbutton.modulate == PlayerData.boots_color:
			editor.selected_boot_color = bootbutton

	update_selection()

func _on_pressed():
	if type == "Fur":
		player.player_fur.modulate = modulate
		editor.selected_color = self
		PlayerData.fur_color = modulate
		for life in get_tree().get_nodes_in_group("challenge_life"):
			life.fur.modulate = modulate
	if type == "Eye":
		player.player_eyes.modulate = modulate
		editor.selected_eye_color = self
		PlayerData.eye_color = modulate
		for life in get_tree().get_nodes_in_group("challenge_life"):
			life.eyes.modulate = modulate
	if type == "Glove":
		player.player_gloves.modulate = modulate
		editor.selected_glove_color = self
		PlayerData.gloves_color = modulate
	if type == "Boot":
		player.player_boots.modulate = modulate
		editor.selected_boot_color = self
		PlayerData.boots_color = modulate

	update_selection()
