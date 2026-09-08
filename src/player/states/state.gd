extends Node
class_name State

@warning_ignore("unused_signal")
signal transitioned(state: State, new_state_name: String)

var player: Player

# Called when the node enters the scene tree for the first time.
func enter():
	pass

func exit():
	pass

func physics_update(_delta):
	pass
