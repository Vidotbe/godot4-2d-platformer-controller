extends Sprite2D

var player_grabbed_key = false

var key_used = false

@onready var spawn_point = $KeySpawn
@onready var heart_key = preload("res://src/components/objects/environmental/heart_key.tscn")
@onready var spade_key = preload("res://src/components/objects/environmental/spade_key.tscn")


@export var key_type : String = "null"

var item_to_spawn = null 

var active_key : Node2D = null



func _process(_delta):
	if key_used:
		return
	if active_key != null:
		if active_key.grabbed and not player_grabbed_key:
			player_grabbed_key = true


func _ready():
	spawn_key()
	EventBus.key_time_limit.connect(reset_active_key)
	EventBus.door_opened.connect(close_box)


func spawn_key():
	if key_used:
		return
	if not key_used:
		get_key_to_spawn()
		var key = item_to_spawn.instantiate()
		get_tree().current_scene.call_deferred("add_child", key)
		active_key = key
		key.global_position = spawn_point.global_position

func get_key_to_spawn():
	if key_type == "heart":
		item_to_spawn = heart_key
	if key_type == "spade":
		item_to_spawn = spade_key

func reset_active_key():
	if player_grabbed_key:
		active_key = null
		player_grabbed_key = false
		spawn_key()


func close_box():
	if player_grabbed_key:
		key_used = true
		active_key = null
		frame = 1
