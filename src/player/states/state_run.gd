extends State


func enter():
	if player:
		check_animation()
	player.air_dashes_left = player.air_dash_amount

func exit():
	pass

func physics_update(delta):
	if player.is_on_floor():
		check_animation()
		if player.hold_to_run:
			if player.move_direction == 1: #RIGHT
				if Input.is_action_pressed("right"):
					if player.velocity.x <= 0:
						player.velocity.x = move_toward(player.velocity.x, player.running_speed, player.ground_friction * delta)
					else:
						if Input.is_action_pressed("run"):
							player.velocity.x = move_toward(player.velocity.x, player.running_speed, player.acceleration * delta)
						else:
							player.velocity.x = move_toward(player.velocity.x, player.walking_speed, player.acceleration * delta)
				else:
					transitioned.emit(self, "Idle")

			elif player.move_direction == -1: #LEFT
				if Input.is_action_pressed("left"):
					if player.velocity.x >= 0:
						player.velocity.x = move_toward(player.velocity.x, -player.running_speed, player.ground_friction * delta)
					else:
						if Input.is_action_pressed("run"):
							player.velocity.x = move_toward(player.velocity.x, -player.running_speed, player.acceleration * delta)
						else:
							player.velocity.x = move_toward(player.velocity.x, -player.walking_speed, player.acceleration * delta)
				else:
					transitioned.emit(self, "Idle")

		else:
			if player.move_direction == 1: #RIGHT
				if Input.is_action_pressed("right"):
					if player.velocity.x <= 0:
						player.velocity.x = move_toward(player.velocity.x, player.running_speed, player.ground_friction * delta)
					else:
						player.velocity.x = move_toward(player.velocity.x, player.running_speed, player.acceleration * delta)
				else:
					transitioned.emit(self, "Idle")

			elif player.move_direction == -1: #LEFT
				if Input.is_action_pressed("left"):
					if player.velocity.x >= 0:
						player.velocity.x = move_toward(player.velocity.x, -player.running_speed, player.ground_friction * delta)
					else:
						player.velocity.x = move_toward(player.velocity.x, -player.running_speed, player.acceleration * delta)
				else:
					transitioned.emit(self, "Idle")

		if Input.is_action_just_pressed("jump"):
			player.velocity.y = player.jump_height
			player.jump_sfx.play()
			player.is_jumping = true
			transitioned.emit(self, "Fall")
			player.animation.start("jump")
			player.jump_particles()
			return

		if Input.is_action_pressed("down"):
			if player.slide_enabled:
				player.apply_crouch_shape()
				transitioned.emit(self, "Slide")
				player.animation.start("slide")
				return

			player.apply_crouch_shape()
			transitioned.emit(self, "Crouch")
			player.animation.travel("crouch")
			return

		if Input.is_action_just_pressed("airdash") and player.air_dash_enabled and player.air_dashes_left > 0 and player.air_dash_cooldown_timer.is_stopped():
			player.get_air_dash_direction()
			player.velocity.x = player.air_dash_speed * player.dash_direction.x
			player.velocity.y = player.air_dash_speed * player.dash_direction.y
			player.animation.start("air_dash")
			transitioned.emit(self, "Air Dash")
			return

	else:
		player.is_jumping = false
		transitioned.emit(self, "Fall")
		player.animation.start("fall")
		return

func check_animation():
	if abs(player.velocity.x) <= player.walk_to_run_threshold:
		player.animation.travel("walk")
	else:
		player.animation.travel("run")
