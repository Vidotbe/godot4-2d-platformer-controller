extends State


func enter():
	pass

func exit():
	pass

func physics_update(delta):
	if player.is_on_floor():
		if not Input.is_action_pressed("down") and not player.ceiling_detect.is_colliding():
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
			return

		player.velocity.x = move_toward(player.velocity.x, 0, player.slide_deceleration * delta)

		if abs(player.velocity.x) < 10:
			transitioned.emit(self, "Crouch")
			player.animation.travel("crouch")
			return
	else:
		player.reset_standing_shape()
		player.is_jumping = false
		transitioned.emit(self, "Fall")
