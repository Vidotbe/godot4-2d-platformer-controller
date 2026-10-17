extends Area2D

@export var door_type : String = "heart"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_body_entered(body):
	if body.active_key != null and body.active_key.key_type == door_type:
		EventBus.emit_signal("door_opened")
		queue_free()
