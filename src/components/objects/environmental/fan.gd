extends Area2D

@export var fan_force = 1500
@export var fan_speed_limit = 200
@export_enum("Up", "Down", "Left", "Right") var launch_direction : String = "Up"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	for body in get_overlapping_bodies():
		if launch_direction == "Up":
			body.apply_fan_force(delta, fan_force, -fan_speed_limit, true)
		if launch_direction == "Down":
			body.apply_fan_force(delta, fan_force, fan_speed_limit, true)
		if launch_direction == "Right":
			body.apply_fan_force(delta, fan_force, fan_speed_limit, false)
		if launch_direction == "Left":
			body.apply_fan_force(delta, fan_force, -fan_speed_limit, false)


func _on_body_entered(body):
	body.is_in_fan = true


func _on_body_exited(body):
	body.is_in_fan = false
