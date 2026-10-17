extends Area2D

@export var color_editor : CanvasLayer = null


func _on_body_entered(_body):
	color_editor.active = true


func _on_body_exited(_body):
	color_editor.active = false
