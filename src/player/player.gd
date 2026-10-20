extends CharacterBody2D
class_name Player


var move_direction : float = 1
var is_jumping = false
var can_double_jump = false
var can_air_dash = true

var just_died = false
var used_wand = false
var is_invincible = false

@export_category("Skills")
@export var double_jump_enabled = false
@export var slide_enabled = false
@export var ledge_grab_enabled = false
@export var wall_slide_enabled = false
@export var air_dash_enabled = false
@export var hold_to_run = false


@export_category("Movement")
@export var jump_height = -400
@export var gravity = 860
@export var player_variable_jump_brake = 2000
@export var fall_speed = 500
@export var running_speed = 200
@export var walking_speed = 100
@export var crouch_walk_speed = 40
@export var acceleration = 400
@export var ground_friction = 2000
@export var air_friction = 2000
@export var air_downward_gravity = 1200
@export var wall_slide_deceleration_up = 800
@export var wall_slide_deceleration = 400
@export var wall_slide_fall_speed = 200
@export var wall_slide_grip = 2000
@export var wall_jump_height = -400
@export var wall_jump_push = -200
@export var slide_deceleration = 20

#AIRDASH
@export var horizontal_only = false
@export var active_gravity = false
@export var air_dash_speed = 600
@export var air_dash_deceleration = 1600
@export var air_dash_duration = 0.3
@export var air_dash_cooldown = 0.1
@export var air_dash_amount = 0

var air_dashes_left = air_dash_amount

var dash_direction : Vector2 = Vector2.ZERO

@export_category("Animation Thresholds")
@export var downward_fall_animation = 50
@export var walk_to_run_threshold = 150
@export var wall_slide_up_threshold = 0
@export var wall_slide_down_threshold = 100



@export_category("Jump Polish")
@export var jump_buffer_time = 0.2
@export var coyote_time = 0.2



@onready var state_machine : StateMachine = $StateMachine
@onready var animation = $AnimationTree.get("parameters/playback")
@onready var collision_shape = $CollisionShape2D
@onready var ceiling_detect : ShapeCast2D = $CeilingDetect
@onready var wall_detect : ShapeCast2D = $WallDetect
@onready var ledge_detect : ShapeCast2D = $"StateMachine/Ledge Grab/LedgeDetect"
@onready var ledge_snap : RayCast2D = $"StateMachine/Ledge Grab/LedgeSnap"
@onready var ledge_cooldown : Timer = $"StateMachine/Ledge Grab/LedgeCooldown"
@onready var jump_buffer_timer : Timer = $StateMachine/Fall/Jump_Buffer
@onready var coyote_time_timer : Timer = $StateMachine/Fall/Coyote_Time
@onready var air_dash_duration_timer : Timer = $"StateMachine/Air Dash/DurationTimer"
@onready var air_dash_cooldown_timer : Timer = $"StateMachine/Air Dash/CooldownTimer" 
@onready var wall_snap_raycast : RayCast2D = $"StateMachine/Ledge Grab/WallSnapRaycast"

@onready var camera : Camera2D = $Camera2D


@onready var standing_height = collision_shape.shape.size.y
@onready var standing_position = collision_shape.position.y

@export var crouch_height = 11

var respawn_position : Vector2 = Vector2(0,0)

var is_in_fan = false
var used_spring = false

@onready var key_follow = $KeyFollow
var active_key : Area2D = null

#SOUND EFFECTS HERE SIR
@onready var jump_sfx : AudioStreamPlayer2D = $SoundEffects/JumpSfx
@onready var green_sfx : AudioStreamPlayer2D = $SoundEffects/GreenGemSfx
@onready var red_sfx : AudioStreamPlayer2D = $SoundEffects/RedDiamondSfx
@onready var spring_sfx : AudioStreamPlayer2D = $SoundEffects/SpringSfx
@onready var respawn_sfx : AudioStreamPlayer2D = $SoundEffects/RespawnSfx
@onready var ledgegrab_sfx : AudioStreamPlayer2D = $SoundEffects/LedgeGrabSfx
@onready var ledgegetup_sfx : AudioStreamPlayer2D = $SoundEffects/LedgeGetupSfx
@onready var keyexplode_sfx : AudioStreamPlayer2D = $KeyFollow/Explosion
@onready var airdash_sfx : AudioStreamPlayer2D = $SoundEffects/AirDashSfx


@onready var warp_effect_animation : AnimatedSprite2D = $ExplodeWarp

# EYE STUFF HERE, IN CASE ITS MORE THAN JUST THE REFERENCE
@onready var player_eyes : Sprite2D = $Eyes
@onready var player_fur : Sprite2D = $Sprite2D
@onready var player_gloves : Sprite2D = $Gloves
@onready var player_boots : Sprite2D = $Boots


var fast_travel_target : Vector2 = Vector2(0,0)
var is_travelling = false

func _ready():
	state_machine.init(self)
	respawn_position = global_position
	set_timers()
	EventBus.item_collected.connect(_on_item_collected)
	EventBus.key_time_limit.connect(reset_active_key)
	EventBus.door_opened.connect(reset_active_key)
	EventBus.reset_awareness.connect(reset_awareness)


func _physics_process(delta):
	state_machine.physics_update(delta)
	move_and_slide()
	if active_key != null:
		active_key.global_position = key_follow.global_position

func _process(delta):
	check_move_direction(delta)

func reset_active_key():
	active_key = null
	keyexplode_sfx.play()
	$KeyFollow/Explode.play("default")

func check_move_direction(delta):
	if move_direction == 1: #RIGHT
		$Sprite2D.flip_h = false
		player_eyes.flip_h = false
		player_gloves.flip_h = false
		player_boots.flip_h = false
		wall_detect.position.x = 5
		ledge_detect.position.x = 5
		ledge_snap.position.x = 11
		wall_snap_raycast.target_position.x = 6
		if active_key != null:
			key_follow.position.x = move_toward(key_follow.position.x, -12, acceleration * delta)

	elif move_direction == -1: #LEFT
		$Sprite2D.flip_h = true
		player_eyes.flip_h = true
		player_gloves.flip_h = true
		player_boots.flip_h = true
		wall_detect.position.x = -5
		ledge_detect.position.x = -5
		ledge_snap.position.x = -11
		wall_snap_raycast.target_position.x = -6
		if active_key != null:
			key_follow.position.x = move_toward(key_follow.position.x, 12, acceleration * delta)

func use_spring(impulse: Vector2, vertical : bool = true):
	spring_sfx.play()
	air_dashes_left = air_dash_amount
	can_double_jump = true
	reset_standing_shape()
	used_spring = true
	if vertical:
		velocity.y = impulse.y
	else:
		velocity.x = impulse.x

func apply_fan_force(delta, fan_force : float, fan_limit: float, vertical : bool = true):
	if vertical:
		velocity.y = move_toward(velocity.y, fan_limit, fan_force * delta)

	else:
		velocity.x = move_toward(velocity.x, fan_limit, fan_force * delta)

func reset_awareness():
	used_wand = true
	player_eyes.show()
	camera.limit_left = -3207
	camera.limit_right = 2936

func start_fast_travel(target : Vector2):
	fast_travel_target = target
	is_travelling = true
	velocity.x = 0
	velocity.y = 0
	if active_key != null:
		reset_active_key()
	state_machine.child_transitioned(state_machine.current_state, "Fast Travel")

func warp_effect():
	if warp_effect_animation.is_playing():
		warp_effect_animation.stop()
	warp_effect_animation.play()
	keyexplode_sfx.play()

func set_timers():
	air_dash_cooldown_timer.wait_time = air_dash_cooldown
	air_dash_duration_timer.wait_time = air_dash_duration
	jump_buffer_timer.wait_time = jump_buffer_time
	coyote_time_timer.wait_time = coyote_time

func apply_crouch_shape():
	var height_difference = standing_height - crouch_height

	collision_shape.shape.size.y = crouch_height
	collision_shape.position.y = standing_position + (height_difference / 2)

func reset_standing_shape():
	collision_shape.shape.size.y = standing_height
	collision_shape.position.y = standing_position

func can_stand_up():
	ceiling_detect.force_shapecast_update()
	return not ceiling_detect.is_colliding()

func get_air_dash_direction():
	dash_direction = Input.get_vector("left", "right", "up", "down")
	if horizontal_only:
		dash_direction.y = 0
	
	if dash_direction == Vector2.ZERO:
		dash_direction.x = move_direction
	
	return dash_direction.normalized()

func respawn():
	if not is_invincible:
		just_died = true
		EventBus.emit_signal("player_respawn")
		global_position = respawn_position
		respawn_sfx.play()
		$Respawn.play("respawn")
		await get_tree().create_timer(0.1, false).timeout
		just_died = false

func _on_item_collected(item_type, _item_value):
	if item_type == "diamond":
		red_sfx.play()
	if item_type == "money":
		green_sfx.play()

func _on_sprite_2d_frame_changed():
	player_eyes.frame = $Sprite2D.frame
	player_gloves.frame = player_fur.frame
	player_boots.frame = player_fur.frame
