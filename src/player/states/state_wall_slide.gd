extends State

var particle_timer : float = 0.0
var particle_timer_interval : float = 0.1

func enter():
	pass

func exit():
	pass

func physics_update(delta):
	if not player.is_on_floor():
		if player.wall_detect.is_colliding():
			if player.velocity.y > player.wall_slide_fall_speed:
				player.velocity.y = move_toward(player.velocity.y, player.wall_slide_fall_speed, player.wall_slide_grip * delta)
	
			if player.velocity.y < player.wall_slide_up_threshold:
				player.velocity.y = move_toward(player.velocity.y, player.wall_slide_fall_speed, player.wall_slide_deceleration_up * delta)
			else:
				player.velocity.y = move_toward(player.velocity.y, player.wall_slide_fall_speed, player.wall_slide_deceleration * delta)

			check_wall_slide_animation()
			wall_slide_particles(delta)
		
		
			if Input.is_action_just_pressed("jump"):
				player.velocity.y = player.wall_jump_height
				player.velocity.x = player.wall_jump_push * player.move_direction
				player.jump_sfx.play()
				player.is_jumping = true
				transitioned.emit(self, "Fall")
				player.move_direction *= -1
				player.wall_jump_particles()
				player.animation.start("jump")
				return
		
			if player.move_direction == 1:
				if Input.is_action_just_pressed("left"):
					player.move_direction = 1
					player.is_jumping = true
					transitioned.emit(self, "Fall")
					player.animation.start("fall")
					return
			else:
				if Input.is_action_just_pressed("right"):
					player.move_direction = -1
					player.is_jumping = true
					transitioned.emit(self, "Fall")
					player.animation.start("fall")
					return
		
		elif not player.wall_detect.is_colliding():
			player.is_jumping = true
			transitioned.emit(self, "Fall")
			player.animation.start("fall")
			return

		if player.wall_detect.is_colliding() and not player.ledge_detect.is_colliding() and player.wall_snap_raycast.is_colliding() and player.ledge_grab_enabled and player.ledge_cooldown.is_stopped():
			transitioned.emit(self, "Ledge Grab")
			return

		if Input.is_action_just_pressed("airdash") and player.air_dash_enabled and player.air_dashes_left > 0 and player.air_dash_cooldown_timer.is_stopped():
			player.get_air_dash_direction()
			player.velocity.x = player.air_dash_speed * player.dash_direction.x * -1
			player.velocity.y = player.air_dash_speed * player.dash_direction.y
			player.animation.start("air_dash")
			player.move_direction *= -1
			transitioned.emit(self, "Air Dash")
			return

	else:
		transitioned.emit(self, "Idle")
		return

func wall_slide_particles(delta):
	particle_timer += delta
	if particle_timer >= particle_timer_interval:
		player.wall_slide_particles()
		particle_timer = 0.0

func check_wall_slide_animation():
	if player.velocity.y < player.wall_slide_up_threshold:
		player.animation.travel("wall_slide_up")
	elif player.velocity.y > player.wall_slide_up_threshold and player.velocity.y < player.wall_slide_down_threshold:
		player.animation.travel("wall_slide")
	elif player.velocity.y > player.wall_slide_up_threshold and player.velocity.y > player.wall_slide_down_threshold:
		player.animation.travel("wall_slide_down")
	else:
		player.animation.travel("wall_slide")
