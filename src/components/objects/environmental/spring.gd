extends Area2D

@export var launch_force = 1.5

@export_enum("Up", "Down", "Left", "Right") var launch_direction : String = "Up"

var total_launch_force = 0



func _on_body_entered(body):
	total_launch_force = body.jump_height * -launch_force
	if body.has_method("use_spring"):
		var launch_vector: Vector2 = Vector2.UP
		
		match launch_direction:
			"Up": launch_vector = Vector2.UP
			"Down": launch_vector = Vector2.DOWN
			"Left": launch_vector = Vector2.LEFT
			"Right": launch_vector = Vector2.RIGHT
		
		if launch_vector == Vector2.UP or launch_vector == Vector2.DOWN:
			body.use_spring(total_launch_force * launch_vector, true)
		
		else:
			body.use_spring(total_launch_force * launch_vector, false)
		
		$AnimationPlayer.play("used")
		
