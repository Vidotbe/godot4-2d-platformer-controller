extends State


func enter():
	player.apply_crouch_shape()

func exit():
	player.reset_standing_shape()

func physics_update(delta):
	if player.is_on_floor():
		if not Input.is_action_pressed("down"):
			if player.can_stand_up():
				player.reset_standing_shape()
				transitioned.emit(self, "Idle")
				return

		if Input.is_action_just_pressed("jump") and not player.ceiling_detect.is_colliding():
			player.reset_standing_shape()
			player.velocity.y = player.jump_height
			player.jump_sfx.play()
			player.is_jumping = true
			transitioned.emit(self, "Fall")
			player.animation.start("jump")
			player.jump_particles()
			return

		if player.move_direction == 1: #RIGHT
			if Input.is_action_pressed("right"):
				player.animation.travel("crouch_walk")
				if player.velocity.x <= 0:
					player.velocity.x = move_toward(player.velocity.x, player.crouch_walk_speed, player.ground_friction * delta)
				else:
					player.velocity.x = move_toward(player.velocity.x, player.crouch_walk_speed, player.acceleration * delta)
			elif Input.is_action_pressed("left"):
				player.move_direction = -1
			else:
				player.velocity.x = 0
				player.animation.travel("crouch")

		elif player.move_direction == -1: #LEFT
			if Input.is_action_pressed("left"):
				player.animation.travel("crouch_walk")
				if player.velocity.x >= 0:
					player.velocity.x = move_toward(player.velocity.x, -player.crouch_walk_speed, player.ground_friction * delta)
				else:
					player.velocity.x = move_toward(player.velocity.x, -player.crouch_walk_speed, player.acceleration * delta)
			elif Input.is_action_pressed("right"):
				player.move_direction = 1
			else:
				player.velocity.x = 0
				player.animation.travel("crouch")

	else:
		player.reset_standing_shape()
		transitioned.emit(self, "Fall")
