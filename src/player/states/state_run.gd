extends State


func enter():
	if player:
		check_animation()

func exit():
	pass

func physics_update(delta):
	if player.is_on_floor():
		check_animation()
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
			player.is_jumping = true
			transitioned.emit(self, "Fall")
			player.animation.start("jump")
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
