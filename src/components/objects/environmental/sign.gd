extends Area2D

@export var sign_information : String = "This is the TEST SIGN!"
@onready var label : Label = $Label

@onready var label0 : Label = $Label0
@export var his = false

@export var weird = false

func _ready():
	if his:
		$Sprite2D.modulate = Color.BLACK
		label0.text = str(sign_information)

	label.text = str(sign_information)

func _on_body_entered(_body):
	if his:
		label0.show()
		return
	if weird:
		_ready()
		weird = false
	label.show()

func _on_body_exited(_body):
	if his:
		return
	label.hide()
