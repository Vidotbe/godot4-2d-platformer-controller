extends CanvasLayer


@onready var diamond_label = $MarginContainer/HBoxContainer/Label
@onready var money_label = $Money
@onready var wand_button : Button = $Wand

@onready var wand_sfx : AudioStreamPlayer = $SoundEffects/WandSfx
@onready var warp_locked_sfx : AudioStreamPlayer = $SoundEffects/WarpLockedSfx
@onready var warp_hover_sfx : AudioStreamPlayer = $SoundEffects/WarpHoverSfx

@export var player : Player = null

var map_active = false
@onready var map : Control = $Map
@onready var area_name : Label = $Map/AreaName

@onready var buy_sfx : AudioStreamPlayer = $buy_sfx

@onready var notif : AnimationPlayer = $Notif

@export var diamond_count = 0
var max_diamonds = 50

@export var money_count = 0

@warning_ignore("unused_signal")

var checkpoints : Dictionary = {}

var map_speed_up : float = 15.0
var map_speed_down = 1500

var time_to_go = false

var challenge_position = Vector2(-2407, 1944)

func _ready():
	EventBus.item_collected.connect(_on_item_collected)
	EventBus.update_checkpoint_status.connect(register_checkpoints)
	EventBus.on_all_diamonds.connect(notify)
	EventBus.start_challenge.connect(send_to_challenge)

	var base_size = Vector2i(480, 270)
	var scale_factor = 3

	var window_size = base_size * scale_factor
	
	DisplayServer.window_set_size(window_size)

	var screen_center := DisplayServer.screen_get_position() + (DisplayServer.screen_get_size() / 2)
	DisplayServer.window_set_position(screen_center - (window_size / 2))

	if PlayerData.sandbox_mode:
		diamond_count = 1000
		wand_button.show()
		await get_tree().process_frame
		EventBus.emit_signal("reset_awareness")

	update_ui()
	register_checkpoints()
	area_name.text = ""

	if PlayerData.player_has_wand:
		wand_button.show()
		

func _process(delta):
	if map_active:
		map.position.y = lerp(map.position.y, 0.0, map_speed_up * delta)
		if abs(map.position.y) < 0.5:
			map.position.y = 0
	else:
		map.position.y = move_toward(map.position.y, -170, map_speed_down * delta)


	if PlayerData.in_cutscene:
		map_active = false
		wand_button.hide()

	if diamond_count == max_diamonds and not time_to_go:
		time_to_go = true
		EventBus.emit_signal("on_all_diamonds")

func notify():
	notif.play("start")

func register_checkpoints():
	checkpoints.clear()
	
	var nodes_in_group = get_tree().get_nodes_in_group("checkpoint")
	
	for checkpoint in nodes_in_group:
		var checkpoint_id = checkpoint.checkpointID

		checkpoints[checkpoint_id] = {
			"name" : checkpoint.map_name,
			"is_unlocked" : checkpoint.is_unlocked,
			"global_position" : checkpoint.respawn_mark.global_position
		}

	for node in get_tree().get_nodes_in_group("map_points"):
		if node is Button:
			if checkpoints.has(node.ButtonID):
				if PlayerData.sandbox_mode:
					node.self_modulate = Color.WHITE
				else:
					if checkpoints[node.ButtonID]["is_unlocked"]:
						node.self_modulate = Color.WHITE
					else:
						node.self_modulate = Color.RED


func send_to_challenge():
	player.start_fast_travel(challenge_position)


func _on_item_collected(item_type: String, item_value: int):
	if item_type == "diamond":
		diamond_count += item_value
		update_ui()
	if item_type == "money":
		money_count += item_value
		update_ui()
	if item_type == "magic_wand":
		wand_button.show()
		PlayerData.player_has_wand = true

func update_ui():
	if PlayerData.sandbox_mode:
		diamond_label.text = "Infinite"
	else:
		diamond_label.text = str(diamond_count) + " / " + str(max_diamonds)
	money_label.text = str(money_count)


func _on_wand_pressed():
	if PlayerData.in_cutscene:
		return
	wand_sfx.play()
	if map_active:
		map_active = false
	else:
		map_active = true


func _on_map_button_pressed(ButtonID):
	if PlayerData.in_cutscene:
		return
	if not checkpoints.has(ButtonID):
		return
	
	var checkpoint_data = checkpoints[ButtonID]
	
	if PlayerData.sandbox_mode:
		if not player.is_travelling:
			player.start_fast_travel(checkpoint_data["global_position"]) 
			player.warp_effect()
	else:
		if checkpoint_data["is_unlocked"] and not player.is_travelling:
			player.start_fast_travel(checkpoint_data["global_position"]) 
			player.warp_effect()
			if not player.used_wand:
				EventBus.emit_signal("reset_awareness")
		else:
			warp_locked_sfx.play()

func _on_map_button_mouse_entered(ButtonID):
	if checkpoints.has(ButtonID):
		var checkpoint_data = checkpoints[ButtonID]

		if checkpoint_data["is_unlocked"]:
			area_name.text = checkpoint_data["name"]
		else:
			area_name.text = checkpoint_data["name"] + " LOCKED"
	warp_hover_sfx.play()

func _on_map_button_mouse_exited():
	area_name.text = ""
