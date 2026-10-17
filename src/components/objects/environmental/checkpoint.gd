extends Area2D

@onready var respawn_mark = $Marker2D

@onready var active_sfx : AudioStreamPlayer2D = $ActiveSfx

var is_unlocked = false
@export var checkpointID = 0
@export var map_name : String = ""


func _ready():
	EventBus.update_checkpoint.connect(on_update_checkpoint)


func _on_body_entered(body):
	if not is_unlocked:
		is_unlocked = true
		EventBus.emit_signal("update_checkpoint_status")
	if EventBus.active_checkpoint != self:
		EventBus.active_checkpoint = self
		$Sprite2D.frame = 1
		active_sfx.play()
		body.respawn_position = respawn_mark.global_position
		EventBus.emit_signal("update_checkpoint")

func on_update_checkpoint():
	if EventBus.active_checkpoint != self:
		$Sprite2D.frame = 0
