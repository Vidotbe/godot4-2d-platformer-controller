extends Area2D


@export var drop_list : Array = ["diamond","diamond","diamond", "money", "money", "money", "money", "money", "money", "money", "money", "money"]

var drop_index = 0

var opened = false
var diamond = preload("res://src/components/objects/collectible/collectible.tscn")
var money = preload("res://src/components/objects/collectible/money_collectible.tscn")
var magic_wand = preload("res://src/components/objects/collectible/magic_wand.tscn")

@export var tutorial_chest = false

@onready var spawn_timer : Timer = $SpawnTime
@onready var spawn_pos : Marker2D = $SpawnPosition

@onready var rewards_sfx : AudioStreamPlayer2D = $Rewards
@onready var open_sfx : AudioStreamPlayer2D = $OpenChest

@export var voice_player : Area2D = null

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func spawn_red():
	var red : Area2D = diamond.instantiate()
	var random_x = randi_range(-10, 10)
	red.global_position = spawn_pos.global_position + Vector2(random_x, 0)
	red.coming_from_chest = true
	get_tree().current_scene.add_child(red)


func spawn_green():
	var green : Area2D = money.instantiate()
	var random_x = randi_range(-10, 10)
	green.global_position = spawn_pos.global_position + Vector2(random_x, 0)
	green.coming_from_chest = true
	get_tree().current_scene.add_child(green)

func spawn_wand():
	var wand : Area2D = magic_wand.instantiate()
	var random_x = randi_range(-10, 10)
	wand.global_position = spawn_pos.global_position + Vector2(random_x, 0)
	wand.coming_from_chest = true
	get_tree().current_scene.add_child(wand)

func _on_body_entered(_body):
	if not opened:
		opened = true
		$Sprite2D.frame = 1
		spawn_timer.start()
		open_sfx.play()
		await get_tree().create_timer(spawn_timer.wait_time, false).timeout
		rewards_sfx.play()
		if tutorial_chest:
			voice_player.request_context_dialog("wavedash_tutorial_complete")


func _on_spawn_time_timeout():
	if drop_index < drop_list.size():
		var current_item = drop_list[drop_index]
		
		match current_item:
			"diamond":
				spawn_red()
			"money":
				spawn_green()
			"magic_wand":
				spawn_wand()
		
		drop_index += 1
		
		if drop_index >= drop_list.size():
			spawn_timer.stop()
			rewards_sfx.stop()
	else:
		spawn_timer.stop()
		rewards_sfx.stop()
