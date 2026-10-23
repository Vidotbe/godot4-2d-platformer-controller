extends CanvasLayer

@export var active = true

@export var player : Player

@onready var JumpHeightSlider = $CategoryContainer/Jumping/TopSliders/Container/VBoxContainer/TopSliders/VBoxContainer2/JumpHeightSlider
@onready var GravitySlider = $CategoryContainer/Jumping/TopSliders/Container/VBoxContainer/TopSliders/VBoxContainer3/GravitySlider
@onready var FallSpeedSlider = $CategoryContainer/Jumping/TopSliders/Container/VBoxContainer/TopSliders/VBoxContainer4/FallSpeedSlider
@onready var FallAccelerationSlider = $CategoryContainer/Jumping/Bottomsliders/MarginContainer/VBoxContainer2/BottomSliders/VBoxContainer2/FallAccelerationSlider
@onready var AirDecelerationSlider = $CategoryContainer/Jumping/Bottomsliders/MarginContainer/VBoxContainer2/BottomSliders/VBoxContainer3/AirDecelerationSlider
@onready var JumpingBrakeSlider = $CategoryContainer/Jumping/Bottomsliders/MarginContainer/VBoxContainer2/BottomSliders/VBoxContainer4/JumpingBrakeSlider

@onready var RunningSpeedSlider = $CategoryContainer/Running/TopSliders/Container/VBoxContainer/TopSliders/VBoxContainer2/RunningSpeedSlider
@onready var AccelerationSlider = $CategoryContainer/Running/TopSliders/Container/VBoxContainer/TopSliders/VBoxContainer3/AccelerationSlider
@onready var DecelerationSlider = $CategoryContainer/Running/TopSliders/Container/VBoxContainer/TopSliders/VBoxContainer4/DecelerationSlider
@onready var CrouchRunSpeedSlider = $CategoryContainer/Running/Bottomsliders/MarginContainer/VBoxContainer2/BottomSliders/VBoxContainer3/CrouchRunSpeedSlider

@onready var WallSlideUpSlider = $"CategoryContainer/Wall Slide/TopSliders/Container/VBoxContainer/TopSliders/VBoxContainer2/WallSlideUpSlider"
@onready var WallSlideDownSlider = $"CategoryContainer/Wall Slide/TopSliders/Container/VBoxContainer/TopSliders/VBoxContainer3/WallSlideDownSlider"
@onready var MaxSlideSpeedSlider = $"CategoryContainer/Wall Slide/TopSliders/Container/VBoxContainer/TopSliders/VBoxContainer4/MaxSlideSpeedSlider"
@onready var WallSlideGripSLider = $"CategoryContainer/Wall Slide/Bottomsliders/MarginContainer/VBoxContainer2/BottomSliders/VBoxContainer2/WallSlideGripSlider"
@onready var WallJumpHeightSlider = $"CategoryContainer/Wall Slide/Bottomsliders/MarginContainer/VBoxContainer2/BottomSliders/VBoxContainer3/WallJumpHeightSlider" 
@onready var WallKickForceSlider = $"CategoryContainer/Wall Slide/Bottomsliders/MarginContainer/VBoxContainer2/BottomSliders/VBoxContainer4/WallKickForceSlider"

@onready var SlideDecelerationSlider = $CategoryContainer/Skills/SlideDecelerationSlider




@export var categories : Array = ["Jumping", "Running", "Skills", "Adjustments"]
var index = 0

@onready var category_container = $CategoryContainer
@onready var category_name : Label = $Category/Label
@onready var previous_button = $Category/PreviousButton
@onready var next_button = $Category/NextButton


@onready var description_label : Label = $DescriptionLabel 

@onready var capacity_label : Label = $Capacity/Amount
@onready var money_label : Label = $Money/Amount

@onready var window_number : Label = $WindowNumber


var default_values : Dictionary = {}


#SOUND EFFECTS RIGHT HERE FOR THE UI. KEEP IT RETRO 8 BIT, RETRO SOUNDS FOR UI STUFF
@onready var reset_vars_sfx : AudioStreamPlayer = $"Sound Effects/ResetVars"
@onready var denied_sfx : AudioStreamPlayer = $"Sound Effects/Denied"
@onready var edit_sfx : AudioStreamPlayer = $"Sound Effects/EditButton"
@onready var category_sfx : AudioStreamPlayer = $"Sound Effects/CategorySound"
@onready var console_open_sfx : AudioStreamPlayer = $"Sound Effects/ConsoleOpen"
@onready var console_close_sfx : AudioStreamPlayer = $"Sound Effects/ConsoleClose"


@export var hud : CanvasLayer = null

var console_speed_up : float = 15.0
var console_speed_down = 1500
var capacity_used = 0

@export_category("USE THESE TO FUCKING CHEAT")
@export var maximum_capacity = 0

@export var total_money = 0




#SLIDER TEXTURES
@onready var slider_texture : Texture2D = preload("res://assets/ui/console/slider.png")
@onready var slider_empty_texture : Texture2D = preload("res://assets/ui/console/slider_empty.png")
@onready var slider_grabber : String = "res://assets/ui/console/slider_grabber.png"

#BUTTON TEXTURES
@onready var minus_normal_texture : Texture2D = preload("res://assets/ui/console/minus_button_normal.png")
@onready var minus_hover_texture : Texture2D = preload("res://assets/ui/console/minus_button_hover.png")
@onready var minus_press_texture : Texture2D = preload("res://assets/ui/console/minus_button_press.png")

@onready var plus_normal_texture : Texture2D = preload("res://assets/ui/console/plus_button_normal.png")
@onready var plus_hover_texture : Texture2D = preload("res://assets/ui/console/plus_button_hover.png")
@onready var plus_press_texture : Texture2D = preload("res://assets/ui/console/plus_button_press.png")

@onready var checkbox_unchecked_texture : String = "res://assets/ui/console/skill_button_normal.png"
@onready var checkbox_checked_texture : String = "res://assets/ui/console/skill_button_pressed.png"



func _ready():
	if PlayerData.sandbox_mode:
		maximum_capacity = 1000
		categories += ["Wall Slide", "Air Dash", "Themes"]

	update_ui()

	update_window_number()

	update_capacity()

	store_default_values(category_container)
	
	set_slider_texture()
	
	set_button_texture()
	
	set_checkbox_texture()
	
	EventBus.item_collected.connect(_on_item_collected)

	EventBus.skill_bought.connect(_on_skill_bought)

	

	#JUMPING
	setup_hover($CategoryContainer/Jumping/TopSliders/Container/VBoxContainer/TopSliders/VBoxContainer2/Label, "Tune maximum jump height.")
	setup_hover($CategoryContainer/Jumping/TopSliders/Container/VBoxContainer/TopSliders/VBoxContainer3/Label, "How fast you reach maximum height.")
	setup_hover($CategoryContainer/Jumping/TopSliders/Container/VBoxContainer/TopSliders/VBoxContainer4/Label, "How fast you fall down.")
	setup_hover($CategoryContainer/Jumping/Bottomsliders/MarginContainer/VBoxContainer2/BottomSliders/VBoxContainer2/Label, "How fast you reach Fall Speed.")
	setup_hover($CategoryContainer/Jumping/Bottomsliders/MarginContainer/VBoxContainer2/BottomSliders/VBoxContainer3/Label, "How fast you reach 0 Horizontal Speed.")
	setup_hover($CategoryContainer/Jumping/Bottomsliders/MarginContainer/VBoxContainer2/BottomSliders/VBoxContainer4/Label, "Variable Jump Height.")

	#RUNNING
	setup_hover($CategoryContainer/Running/TopSliders/Container/VBoxContainer/TopSliders/VBoxContainer2/Label, "How fast you can run.")
	setup_hover($CategoryContainer/Running/TopSliders/Container/VBoxContainer/TopSliders/VBoxContainer3/Label, "How fast you reach Maximum Running Speed.")
	setup_hover($CategoryContainer/Running/TopSliders/Container/VBoxContainer/TopSliders/VBoxContainer4/Label, "How fast you come to a stop.")
	setup_hover($CategoryContainer/Running/Bottomsliders/MarginContainer/VBoxContainer2/BottomSliders/VBoxContainer3/Label, "Cool, huh?")
	setup_hover($CategoryContainer/Running/Bottomsliders/MarginContainer/VBoxContainer2/BottomSliders/VBoxContainer2/Label, "How fast you Walk. Hold to Run exclusive.")


	#WALL SLIDING
	setup_hover($"CategoryContainer/Wall Slide/TopSliders/Container/VBoxContainer/TopSliders/VBoxContainer2/Label", "How fast you begin to slide down.")
	setup_hover($"CategoryContainer/Wall Slide/TopSliders/Container/VBoxContainer/TopSliders/VBoxContainer3/Label", "How fast you reach Max Slide Speed.")
	setup_hover($"CategoryContainer/Wall Slide/TopSliders/Container/VBoxContainer/TopSliders/VBoxContainer4/Label", "How fast you slide down.")
	setup_hover($"CategoryContainer/Wall Slide/Bottomsliders/MarginContainer/VBoxContainer2/BottomSliders/VBoxContainer2/Label", "How fast you reach Max Slide Speed if your Fall Speed is bigger.")
	setup_hover($"CategoryContainer/Wall Slide/Bottomsliders/MarginContainer/VBoxContainer2/BottomSliders/VBoxContainer3/Label", "How high your Wall Jump is.")
	setup_hover($"CategoryContainer/Wall Slide/Bottomsliders/MarginContainer/VBoxContainer2/BottomSliders/VBoxContainer4/Label", "How fast you jump out of the wall.")

	#AIR DASHING
	setup_hover($"CategoryContainer/Air Dash/TopSliders/Container/VBoxContainer/TopSliders/VBoxContainer2/Label", "How fast you dash.")
	setup_hover($"CategoryContainer/Air Dash/TopSliders/Container/VBoxContainer/TopSliders/VBoxContainer3/Label", "How fast the dash decelerates.")
	setup_hover($"CategoryContainer/Air Dash/TopSliders/Container/VBoxContainer/TopSliders/VBoxContainer4/Label", "How many times you can dash midair.")
	setup_hover($"CategoryContainer/Air Dash/HorizontalOnly", "Enable to only dash Left or Right.", 12)
	setup_hover($"CategoryContainer/Air Dash/ActiveGravity", "Enable to have gravity pull you down as you dash.", 12)
	setup_hover($"CategoryContainer/Air Dash/DurationLabel", "How long the Dash lasts for.", -6)
	setup_hover($"CategoryContainer/Air Dash/CooldownLabel", "How long you have to wait to perform the next dash.", -8)


	#SKILLS
	setup_hover($CategoryContainer/Skills/PanelContainer/MarginContainer/DoubleJump, "Gain an extra Jump in midair.")
	setup_hover($CategoryContainer/Skills/PanelContainer/MarginContainer2/Slide, "Press Down while running to slide under obstacles and maintain speed.", -16)
	setup_hover($CategoryContainer/Skills/PanelContainer/MarginContainer3/LedgeGrab, "Hang onto ledges, press Up to get up, Down to drop from it, or simply Jump.", -12)
	setup_hover($CategoryContainer/Skills/SlideDecelerationSlider/Label, "How fast the slide takes you to a stop.")
	setup_hover($CategoryContainer/Skills/WallSlide, "Slide on walls by jumping towards them, press Jump to jump out of them.", 6, 64)
	setup_hover($CategoryContainer/Skills/AirDash, "Perform a sudden burst of speed with [J] in any direction.", -12)

	#ADJUSTMENTS
	setup_hover($CategoryContainer/Adjustments/TopSliders/Container/VBoxContainer/TopSliders/VBoxContainer2/Label, "Press Jump before touching the floor or a wall to Jump automatically.")
	setup_hover($CategoryContainer/Adjustments/TopSliders/Container/VBoxContainer/TopSliders/VBoxContainer3/Label, "How much time you have to Jump after falling from the floor.")
	setup_hover($CategoryContainer/Adjustments/HoldToRun, "Enable to Hold [K] to reach Maximum Running Speed, Release to walk.")
	setup_hover($CategoryContainer/Adjustments/ResetVariables, "Resets all the variables. Use if you want to start from scratch.", 18)
	setup_hover($CategoryContainer/Adjustments/Invincibility, "Does what it says, you baby.")
	setup_hover($CategoryContainer/Adjustments/Invincibility/Label, "Does what it says, you baby.", -16)

func _input(event):
	if event is InputEventKey and event.pressed and active:
		if event.keycode >= KEY_1 and event.keycode <= KEY_9:
			var pressed_number = event.keycode - KEY_1
		
			if pressed_number < categories.size():
				index = pressed_number
				category_sfx.play()
				update_ui()
				update_window_number()

		if event.keycode >= KEY_KP_1 and event.keycode <= KEY_KP_9:
			var pressed_number = event.keycode - KEY_KP_1
		
			if pressed_number < categories.size():
				index = pressed_number
				category_sfx.play()
				update_ui()
				update_window_number()

func add_category(category_to_add : String):
	if category_to_add != "null":
		categories += [category_to_add]
		update_window_number()

func update_window_number():
	window_number.text = str(index + 1) + "/" + str(categories.size())

func store_default_values(parent_node : Node):
	for child in parent_node.get_children():
		if child is Range:
			default_values[child] = child.value
		elif child is Button and child.toggle_mode:
			default_values[child] = child.button_pressed
		elif child is Button and child.has_method("reset_times_clicked"):
			default_values[child] = child.times_clicked
		
		if child.get_child_count() > 0:
			store_default_values(child)

func set_slider_texture():
	var style_box := StyleBoxTexture.new()
	style_box.texture = slider_texture
	style_box.content_margin_top = 4
	style_box.content_margin_bottom = 4
	style_box.content_margin_left = 57
	style_box.content_margin_right = 57
	style_box.axis_stretch_horizontal = StyleBoxTexture.AXIS_STRETCH_MODE_TILE


	var slider_empty := StyleBoxTexture.new()
	slider_empty.texture = slider_empty_texture
	slider_empty.content_margin_top = 4
	slider_empty.content_margin_bottom = 4
	slider_empty.content_margin_left = 57
	slider_empty.content_margin_right = 57

	var grabber : Texture2D = load(slider_grabber) 

	var sliders = find_sliders(self)
	
	for slider in sliders:
		if slider is HSlider:
			slider.add_theme_stylebox_override("slider", slider_empty)
			slider.add_theme_stylebox_override("grabber_area", style_box)
			slider.add_theme_stylebox_override("grabber_area_highlight", style_box)
			slider.add_theme_icon_override("grabber_disabled", grabber)
			slider.add_theme_icon_override("grabber", grabber)
			slider.add_theme_icon_override("grabber_highlight", grabber)

func find_sliders(node : Node):
	var sliders : Array = []
	for child in node.get_children(true):
		if child is HSlider:
			sliders.append(child)
		if child.get_child_count() > 0:
			sliders.append_array(find_sliders(child))
	return sliders


func set_button_texture():

	var minus_normal := StyleBoxTexture.new()
	minus_normal.texture = minus_normal_texture
	var minus_hover := StyleBoxTexture.new()
	minus_hover.texture = minus_hover_texture
	var minus_press := StyleBoxTexture.new()
	minus_press.texture = minus_press_texture

	var plus_normal := StyleBoxTexture.new()
	plus_normal.texture = plus_normal_texture
	var plus_hover := StyleBoxTexture.new()
	plus_hover.texture = plus_hover_texture
	var plus_press := StyleBoxTexture.new()
	plus_press.texture = plus_press_texture


	for minus_button : Button in get_tree().get_nodes_in_group("minus_buttons"):
		minus_button.text = ""
		minus_button.add_theme_stylebox_override("normal", minus_normal)
		minus_button.add_theme_stylebox_override("hover", minus_hover)
		minus_button.add_theme_stylebox_override("pressed", minus_press)

	for plus_button : Button in get_tree().get_nodes_in_group("plus_buttons"):
		plus_button.text = ""
		plus_button.add_theme_stylebox_override("normal", plus_normal)
		plus_button.add_theme_stylebox_override("hover", plus_hover)
		plus_button.add_theme_stylebox_override("pressed", plus_press)


func set_checkbox_texture():
	var unchecked_texture : Texture2D = load(checkbox_unchecked_texture)
	var checked_texture : Texture2D = load(checkbox_checked_texture)



	var checkbuttons = find_checkbuttons(self)

	for box in checkbuttons:
		if box is CheckBox:
			box.add_theme_icon_override("unchecked", unchecked_texture)
			box.add_theme_icon_override("checked", checked_texture)


func find_checkbuttons(node : Node):
	var checkbuttons : Array = []
	for child in node.get_children(true):
		if child is CheckBox:
			checkbuttons.append(child)
		if child.get_child_count() > 0:
			checkbuttons.append_array(find_checkbuttons(child))
	return checkbuttons

func _process(delta):
	if Input.is_action_just_pressed("console"):
		toggle_console()

	if active:
		if Input.is_action_just_pressed("next"):
			next_button.pressed.emit()
			update_window_number()
		
		if Input.is_action_just_pressed("previous"):
			previous_button.pressed.emit()
			update_window_number()

	if active:
		offset.y = lerp(offset.y, 0.0, console_speed_up * delta)
		if abs(offset.y) < 0.5:
			offset.y = 0
	else:
		offset.y = move_toward(offset.y, 102, console_speed_down * delta)

func toggle_console():
	if active:
		$DescriptionLabel.hide()
		active = false
		console_close_sfx.play()
	else:
		active = true
		console_open_sfx.play()

func setup_hover(label : Control, description : String, HorizontalOffset : int = 7, VerticalOffset : int = 54):
	if not label: return
	label.mouse_filter = Control.MOUSE_FILTER_PASS
	label.mouse_entered.connect(func():
		description_label.text = description
		
		description_label.reset_size()
		
		description_label.global_position = Vector2(
			label.global_position.x + HorizontalOffset,
			label.global_position.y - VerticalOffset
		)
		description_label.visible = true
		
		)

	label.mouse_exited.connect(func(): 
		description_label.visible = false
		description_label.text = ""
	)

func _on_jump_height_slider_value_changed(value):
	player.jump_height = JumpHeightSlider.value * -1 # WE MULTIPLY BY -1 CUS JUMP HEIGHT NEEDS A NEGATIVE NUMBER TO WORK PROPERLY.


func _on_gravity_slider_value_changed(value):
	player.gravity = GravitySlider.value 


func _on_fall_speed_slider_value_changed(value):
	player.fall_speed = FallSpeedSlider.value


func _on_previous_button_pressed():
	category_sfx.play()
	index = posmod(index - 1, categories.size())
	update_ui()


func _on_next_button_pressed():
	category_sfx.play()
	index = (index + 1) % categories.size()
	update_ui()


func update_ui():
	var current = categories[index]

	category_name.text = current
	
	for child in category_container.get_children():
		if child.name in categories:
			child.visible = (child.name == current)
	


func _on_fall_acceleration_slider_value_changed(value):
	player.air_downward_gravity = FallAccelerationSlider.value


func _on_air_deceleration_slider_value_changed(value):
	player.air_friction = AirDecelerationSlider.value


func _on_jumping_brake_slider_value_changed(value):
	player.player_variable_jump_brake = JumpingBrakeSlider.value


func _on_running_speed_slider_value_changed(value):
	player.running_speed = RunningSpeedSlider.value


func _on_acceleration_slider_value_changed(value):
	player.acceleration = AccelerationSlider.value


func _on_deceleration_slider_value_changed(value):
	player.ground_friction = DecelerationSlider.value


func _on_crouch_run_speed_slider_value_changed(value):
	player.crouch_walk_speed = CrouchRunSpeedSlider.value


func _on_wall_slide_up_slider_value_changed(value):
	player.wall_slide_deceleration_up = WallSlideUpSlider.value


func _on_wall_slide_down_slider_value_changed(value):
	player.wall_slide_deceleration = WallSlideDownSlider.value


func _on_max_slide_speed_slider_value_changed(value):
	player.wall_slide_fall_speed = MaxSlideSpeedSlider.value


func _on_wall_slide_grip_slider_value_changed(value):
	player.wall_slide_grip = WallSlideGripSLider.value


func _on_wall_jump_height_slider_value_changed(value):
	player.wall_jump_height = WallJumpHeightSlider.value * -1


func _on_wall_kick_force_slider_value_changed(value):
	player.wall_jump_push = WallKickForceSlider.value * -1


func _on_double_jump_toggled(toggled_on):
	player.double_jump_enabled = toggled_on


func _on_slide_toggled(toggled_on):
	player.slide_enabled = toggled_on


func _on_slide_deceleration_slider_value_changed(value):
	player.slide_deceleration = SlideDecelerationSlider.value


func _on_ledge_grab_toggled(toggled_on):
	player.ledge_grab_enabled = toggled_on


func _on_wall_slide_toggled(toggled_on):
	player.wall_slide_enabled = toggled_on


func _on_air_dash_toggled(toggled_on):
	player.air_dash_enabled = toggled_on
	$AirDashTip.visible = toggled_on


func _on_air_dash_speed_slider_value_changed(value):
	player.air_dash_speed = value


func _on_air_dash_deceleration_slider_value_changed(value):
	player.air_dash_deceleration = value


func _on_air_dash_amount_slider_value_changed(value):
	player.air_dash_amount = value
	if value == 10:
		$"CategoryContainer/Air Dash/HelperLabels/AirDashAmountHelperLabel".text = str("inf")
	else:
		$"CategoryContainer/Air Dash/HelperLabels/AirDashAmountHelperLabel".text = str(value)


func _on_horizontal_only_toggled(toggled_on):
	player.horizontal_only = toggled_on


func _on_active_gravity_toggled(toggled_on):
	player.active_gravity = toggled_on


func _on_air_dash_duration_slider_value_changed(value):
	player.air_dash_duration = value
	player.set_timers()
	$"CategoryContainer/Air Dash/HelperLabels/DurationHelperLabel".text = "%.1f" % value


func _on_cooldown_slider_value_changed(value):
	player.air_dash_cooldown = value
	player.set_timers()
	$"CategoryContainer/Air Dash/HelperLabels/CooldownHelperLabel".text = "%.1f" % value


func _on_jump_buffer_slider_value_changed(value):
	player.jump_buffer_time = value
	player.set_timers()
	$CategoryContainer/Adjustments/HelperLabels/JumpBufferHelper.text = "%.1f" % value


func _on_coyote_time_slider_value_changed(value):
	player.coyote_time = value
	player.set_timers()
	$CategoryContainer/Adjustments/HelperLabels/CoyoteTimeHelper.text = "%.1f" % value


func _on_hold_to_run_toggled(toggled_on):
	player.hold_to_run = toggled_on
	$RunTip.visible = toggled_on


func _on_walk_speed_slider_value_changed(value):
	player.walking_speed = value


func _on_reset_variables_pressed():
	for node in default_values:
		var start_value = default_values[node]
		
		if node is Range:
			node.value = start_value

		if node is Button:
			if node.has_method("reset_times_clicked"):
				node.reset_times_clicked()

	var sliders = find_sliders(self)
	
	for slider in sliders:
		slider.modulate.s = 0

	capacity_used = 0
	update_capacity()
	reset_vars_sfx.play()


func _on_item_collected(item_type: String, _item_value: int):
	await get_tree().process_frame
	if item_type == "money":
		money_label.text = str(hud.money_count)
	if item_type == "diamond":
		maximum_capacity = hud.diamond_count
		if PlayerData.sandbox_mode:
			capacity_label.text = str(capacity_used) + "/ inf"
		else:
			capacity_label.text = str(capacity_used) + "/" + str(maximum_capacity)

func update_capacity():
	if PlayerData.sandbox_mode:
		capacity_label.text = str(capacity_used) + "/inf"
		
	else:
		capacity_label.text = str(capacity_used) + "/" + str(maximum_capacity)


func _on_skill_bought():
	money_label.text = str(hud.money_count)


func _on_invincibility_toggled(toggled_on):
	player.is_invincible = toggled_on
