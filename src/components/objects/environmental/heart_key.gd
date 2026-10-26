extends Area2D

var grabbed = false
@onready var timer : Timer = $Timer
@export var time_limit : float = 5

@onready var ticking : AudioStreamPlayer2D = $Ticking
@onready var last_sec : AudioStreamPlayer2D = $LastSec

@export var key_type : String = "heart"

var exploding = false

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.wait_time = time_limit
	EventBus.door_opened.connect(despawn_key)
	EventBus.player_respawn.connect(player_died)

func _process(_delta):
	if grabbed and key_type != "diamond":
		check_time_left()

func check_time_left():
	if not $Sprite2D.visible:
		last_sec.stop()
		ticking.stop()
		return
	if timer.time_left > 1.0:
		if not ticking.playing:
			ticking.play()
	else:
		ticking.stop()
		if not last_sec.playing:
			last_sec.play()
		$Animation.play("last_sec")

func player_died():
	if grabbed:
		_on_timer_timeout()


func _on_body_entered(body):
	if not grabbed and body.active_key == null:
		grabbed = true
		body.red_sfx.play()
		body.active_key = self
		$Timer.start()
		if key_type == "diamond":
			EventBus.emit_signal("diamond_key_get")

func despawn_key():
	await get_tree().process_frame
	if grabbed:
		_on_timer_timeout()

func _on_timer_timeout():
	if not key_type != "diamond":
		if not exploding:
			exploding = true
			EventBus.emit_signal("key_time_limit")
			$Explode.show()
			$Explode.play("default")
			$Explosion.play()
			$Sprite2D.hide()
			$Flash.hide()
			await get_tree().create_timer(1.5, false).timeout
			queue_free()
