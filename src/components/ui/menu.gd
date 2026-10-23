extends CanvasLayer

var active = false
var editor_speed_in : float = 15.0
var editor_speed_out = 1500

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active:
		offset.x = lerp(offset.x, 0.0, editor_speed_in * delta)
		if abs(offset.x) < 0.5:
			offset.x = 0
	else:
		offset.x = move_toward(offset.x, 120, editor_speed_out * delta)

	if Input.is_action_just_pressed("menu") and not PlayerData.browser_mode:
		_on_menu_button_pressed()

func _on_restart_pressed():
	get_tree().reload_current_scene()


func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://src/components/ui/title_screen.tscn")


func _on_fullscreen_pressed():
	var current_mode = DisplayServer.window_get_mode()

	if current_mode == DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		

func _on_menu_button_pressed():
	if not active:
		active = true
	else:
		active = false
