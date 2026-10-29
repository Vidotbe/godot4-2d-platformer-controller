extends Area2D

@export var open = false

@onready var door_sprite : Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.on_all_diamonds.connect(open_door)

func open_door():
	pass

func _on_body_entered(body):
	if body.active_key != null and body.active_key.key_type == "diamond":
		PlayerData.adventure_mode_complete = true
		get_tree().call_deferred("change_scene_to_file", "res://src/components/ui/title_screen.tscn")
