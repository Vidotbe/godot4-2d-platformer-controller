extends Node2D

@onready var run_right_particle = preload("res://assets/sprites/particles/dust.tscn")
@onready var run_left_particle = preload("res://assets/sprites/particles/dust_run_left.tscn")
@onready var jump_particle = preload("res://assets/sprites/particles/dust_jump.tscn")
@onready var upwards_particle = preload("res://assets/sprites/particles/dust_upwards.tscn")

@onready var wall_slide_up_particle = preload("res://assets/sprites/particles/dust_wall_slide_up.tscn")
@onready var wall_slide_down_particle = preload("res://assets/sprites/particles/dust_wall_slide_down.tscn")

@onready var dust_wall_particle = preload("res://assets/sprites/particles/dust_wall_jump.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func w_slide_up_dust():
	var offset_x = global_position.x
	var offset_y = global_position.y - 6
	var dust = wall_slide_up_particle.instantiate()
	dust.global_position = Vector2(offset_x,offset_y)
	get_tree().current_scene.add_child(dust)

func w_slide_down_dust():
	var offset_x = global_position.x
	var offset_y = global_position.y - 6
	var dust = wall_slide_down_particle.instantiate()
	dust.global_position = Vector2(offset_x,offset_y)
	get_tree().current_scene.add_child(dust)

func jump_dust():
	var dust = jump_particle.instantiate()
	dust.global_position = global_position
	get_tree().current_scene.add_child(dust)

func wall_jump_dust():
	var dust = dust_wall_particle.instantiate()
	dust.global_position = global_position
	dust.scale.y = get_parent().move_direction * -1
	get_tree().current_scene.add_child(dust)

func upwards_dust():
	var offset_y = global_position.y - 8
	var dust = upwards_particle.instantiate()
	dust.global_position = Vector2(global_position.x, offset_y)
	get_tree().current_scene.add_child(dust)

func run_right_dust():
	var offset_y = global_position.y - 1
	var dust = run_right_particle.instantiate()
	dust.global_position = Vector2(global_position.x, offset_y)
	get_tree().current_scene.add_child(dust)

func run_left_dust():
	var offset_y = global_position.y - 1
	var dust = run_left_particle.instantiate()
	dust.global_position = Vector2(global_position.x, offset_y)
	get_tree().current_scene.add_child(dust)
