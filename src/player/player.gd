extends CharacterBody2D




@export_category("Movement")
@export var jump_height = -400
@export var gravity = 860
@export var running_speed = 200

@onready var state_machine : StateMachine = $StateMachine
@onready var sprite = $AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	state_machine._init(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	state_machine.physics_update(delta)
	move_and_slide()
