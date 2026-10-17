extends State


# Called when the node enters the scene tree for the first time.
func enter():
	player.air_dash_duration_timer.start()
	player.airdash_sfx.play()
	if player.air_dash_amount < 10:
		player.air_dashes_left -= 1

func exit():
	pass

func physics_update(delta):
	player.velocity.x = move_toward(player.velocity.x, 0, player.air_dash_deceleration * delta)
	if player.active_gravity:
		player.velocity.y = move_toward(player.velocity.y, player.fall_speed, player.air_downward_gravity * delta)
	else:
		player.velocity.y = move_toward(player.velocity.y, 0, player.air_dash_deceleration * delta)

	if player.air_dash_duration_timer.is_stopped():
		transitioned.emit(self, "Fall")
		player.air_dash_cooldown_timer.start()
		player.animation.start("fall")
		return

	if player.is_on_floor():
		if player.is_jumping:
			transitioned.emit(self, "Idle")
			player.air_dash_cooldown_timer.start()
			player.air_dash_duration_timer.stop()
			return
		else:
			if Input.is_action_just_pressed("jump"):
				player.velocity.y = player.jump_height
				player.jump_sfx.play()
				player.is_jumping = true
				transitioned.emit(self, "Fall")
				player.animation.start("jump")
				player.air_dash_cooldown_timer.start()
				player.air_dash_duration_timer.stop()
				return

	if player.is_on_wall():
		if player.wall_detect.is_colliding() and player.wall_slide_enabled:
			transitioned.emit(self, "Wall Slide")
			player.air_dash_cooldown_timer.start()
			player.air_dash_duration_timer.stop()
			return
		else:
			transitioned.emit(self, "Fall")
			player.air_dash_cooldown_timer.start()
			player.animation.start("fall")
			return
