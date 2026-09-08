extends CharacterBody2D
class_name Player


var move_direction = 1
var is_jumping = false


@export_category("Movement")
@export var jump_height = -400
@export var gravity = 860
@export var player_variable_jump_brake = 2000
@export var fall_speed = 400
@export var running_speed = 200
@export var acceleration = 400
@export var ground_friction = 2000
@export var air_friction = 2000

@export_category("Animation Thresholds")
@export var downward_fall_animation = 50
@export var walk_to_run_threshold = 150

@export_category("Jump Polish")
@export var jump_buffer_time = 0.2
@export var coyote_time = 0.2



@onready var state_machine : StateMachine = $StateMachine
@onready var animation = $AnimationTree.get("parameters/playback")


func _ready():
	state_machine.init(self)

func _physics_process(delta):
	state_machine.physics_update(delta)
	move_and_slide()

func _process(_delta):
	check_move_direction()

func check_move_direction():
	if move_direction == 1: #RIGHT
		$Sprite2D.flip_h = false
	
	elif move_direction == -1: #LEFT
		$Sprite2D.flip_h = true
