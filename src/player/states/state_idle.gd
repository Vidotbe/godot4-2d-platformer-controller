extends State


# Called when the node enters the scene tree for the first time.
func enter():
	player.air_dashes_left = player.air_dash_amount
	player.is_jumping = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func physics_update(delta):
	if not player.is_on_floor():
		player.is_jumping = false
		transitioned.emit(self, "Fall")
		player.animation.start("fall")
		return
	
	
	if Input.is_action_pressed("down"):
		if abs(player.velocity.x) > 10 and player.slide_enabled:
			if player.slide_enabled:
				player.apply_crouch_shape()
				transitioned.emit(self, "Slide")
				player.animation.start("slide")
				return

		player.apply_crouch_shape()
		transitioned.emit(self, "Crouch")
		player.animation.travel("crouch")
		return
	
	if Input.is_action_just_pressed("jump"):
		player.velocity.y = player.jump_height
		player.jump_sfx.play()
		player.is_jumping = true
		transitioned.emit(self, "Fall")
		player.animation.start("jump")
		player.jump_particles()
		return

	if Input.is_action_pressed("left"):
		player.move_direction = -1
		transitioned.emit(self, "Run")
		return

	elif Input.is_action_pressed("right"):
		player.move_direction = 1
		transitioned.emit(self, "Run")
		return


	if Input.is_action_just_pressed("airdash") and player.air_dash_enabled and player.air_dashes_left > 0 and player.air_dash_cooldown_timer.is_stopped():
		player.get_air_dash_direction()
		player.velocity.x = player.air_dash_speed * player.dash_direction.x
		player.velocity.y = player.air_dash_speed * player.dash_direction.y
		player.animation.start("air_dash")
		transitioned.emit(self, "Air Dash")
		return

	if player.is_on_floor():
		player.velocity.x = move_toward(player.velocity.x, 0, player.ground_friction * delta)
		if abs(player.velocity.x) >= player.walk_to_run_threshold:
			player.animation.travel("run")
			return
		elif abs(player.velocity.x) < player.walk_to_run_threshold and abs(player.velocity.x) > 10:
			player.animation.travel("walk")
			return
		elif abs(player.velocity.x) <= 10:
			player.animation.travel("idle")
			return
