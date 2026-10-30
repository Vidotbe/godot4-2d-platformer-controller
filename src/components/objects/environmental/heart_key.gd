extends Area2D

var grabbed = false
@onready var timer : Timer = $Timer
@export var time_limit : float = 5

@onready var ticking : AudioStreamPlayer2D = $Ticking
@onready var last_sec : AudioStreamPlayer2D = $LastSec

@export var key_type : String = "heart"

var exploding = false

@onready var keysprite : Sprite2D = $Sprite2D

var start_position = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.wait_time = time_limit
	EventBus.door_opened.connect(despawn_key)
	EventBus.player_respawn.connect(player_died)
	EventBus.item_collected.connect(add_shard)
	EventBus.start_challenge.connect(reset_key_position)

	if key_type == "diamond":
		start_position = global_position

func _process(_delta):
	if grabbed and key_type != "diamond":
		check_time_left()

func reset_key_position():
	if key_type == "diamond":
		if grabbed:
			grabbed = false
		global_position = start_position
		keysprite.frame = 0
		show()

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
		if key_type != "diamond":
			_on_timer_timeout()


func _on_body_entered(body):
	if not grabbed and body.active_key == null:
		grabbed = true
		body.red_sfx.play()
		body.active_key = self
		if key_type != "diamond":
			$Timer.start()
		if key_type == "diamond":
			EventBus.emit_signal("diamond_key_get")
			keysprite.frame = 1
			PlayerData.timer_paused = true


func despawn_key():
	await get_tree().process_frame
	if grabbed:
		_on_timer_timeout()

func add_shard(item_type: String, item_value: int):
	if item_type == "key_shard":
		if key_type == "diamond":
			keysprite.frame += item_value
			EventBus.emit_signal("next_challenge")

func _on_timer_timeout():
	if not key_type == "diamond":
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
