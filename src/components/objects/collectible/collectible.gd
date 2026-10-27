extends Area2D

@export var item_type : String = "diamond"
@export var item_value = 1


var coming_from_chest = false
var chest_up = -50

func _ready():
	if coming_from_chest:
		EventBus.item_collected.emit(item_type, item_value)
		await get_tree().create_timer(0.5, false).timeout
		queue_free()


func _process(delta):
	if coming_from_chest:
		global_position.y += chest_up * delta

func _on_body_entered(body):
	if not coming_from_chest:
		if body is Player:
			EventBus.item_collected.emit(item_type, item_value)
			if item_type != "key_shard":
				queue_free()
			else:
				pass
