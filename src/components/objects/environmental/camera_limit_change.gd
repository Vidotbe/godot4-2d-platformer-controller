extends Area2D

@export var limit_left = 0
@export var limit_right = 0
@export var limit_top = 0
@export var limit_bottom = 0

@export var player : Player = null

@export var smoothing_time = 1


func _on_body_entered(_body):
	player.camera.limit_left = limit_left
	player.camera.limit_right = limit_right
	player.camera.limit_top = limit_top
	player.camera.limit_bottom = limit_bottom
