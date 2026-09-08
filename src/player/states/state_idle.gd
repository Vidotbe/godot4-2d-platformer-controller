extends State


# Called when the node enters the scene tree for the first time.
func enter():
	if player:
		player.animation.start("idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func physics_update(delta):
	if not player.is_on_floor():
		player.is_jumping = false
		transitioned.emit(self, "Fall")
		player.animation.start("fall")
		return
	
	if player.is_on_floor():
		player.velocity.x = move_toward(player.velocity.x, 0, player.ground_friction * delta)
		
	
	if Input.is_action_just_pressed("jump"):
		player.velocity.y = player.jump_height
		player.is_jumping = true
		transitioned.emit(self, "Fall")
		player.animation.start("jump")
		return

	if Input.is_action_pressed("left"):
		player.move_direction = -1
		transitioned.emit(self, "Run")
		
	elif Input.is_action_pressed("right"):
		player.move_direction = 1
		transitioned.emit(self, "Run")
