extends State

@onready var coyote_timer : Timer = $Coyote_Time
@onready var jump_buffer : Timer = $Jump_Buffer

var particle_timer : float = 0.0
var particle_timer_interval : float = 0.05

func _ready():
	await owner.ready
	if player:
		coyote_timer.wait_time = player.coyote_time
		jump_buffer.wait_time = player.jump_buffer_time

func enter():
	player.can_double_jump = true
	if not player.is_jumping:
		coyote_timer.start()

func exit():
	if player.used_spring:
		player.used_spring = false


func physics_update(delta):
	if not player.is_on_floor():
		
		if player.velocity.y >= player.downward_fall_animation:
			player.animation.travel("fall")
			player.velocity.y = move_toward(player.velocity.y, player.fall_speed, player.air_downward_gravity * delta)
		else:
			player.velocity.y = move_toward(player.velocity.y, player.fall_speed, player.gravity * delta)
			spawn_upwards_particles(delta)
		
		
		if not Input.is_action_pressed("jump") and player.velocity.y < player.downward_fall_animation and not player.is_in_fan and not player.used_spring:
			player.velocity.y += player.player_variable_jump_brake * delta

		if player.hold_to_run:
			if Input.is_action_pressed("right"):
				if player.velocity.x <= 0:
					player.velocity.x = move_toward(player.velocity.x, player.running_speed, player.air_friction * delta)
				else:
					if Input.is_action_pressed("run"):
						player.velocity.x = move_toward(player.velocity.x, player.running_speed, player.acceleration * delta)
					else:
						player.velocity.x = move_toward(player.velocity.x, player.walking_speed, player.acceleration * delta)
				player.move_direction = 1

			elif Input.is_action_pressed("left"):
				if player.velocity.x >= 0:
					player.velocity.x = move_toward(player.velocity.x, -player.running_speed, player.air_friction * delta)
				else:
					if Input.is_action_pressed("run"):
						player.velocity.x = move_toward(player.velocity.x, -player.running_speed, player.acceleration * delta)
					else:
						player.velocity.x = move_toward(player.velocity.x, -player.walking_speed, player.acceleration * delta)
				player.move_direction = -1

			else:
				player.velocity.x = move_toward(player.velocity.x, 0, player.air_friction * delta)

		else:
			if Input.is_action_pressed("right"):
				if player.velocity.x <= 0:
					player.velocity.x = move_toward(player.velocity.x, player.running_speed, player.air_friction * delta)
				else:
					player.velocity.x = move_toward(player.velocity.x, player.running_speed, player.acceleration * delta)
				player.move_direction = 1

			elif Input.is_action_pressed("left"):
				if player.velocity.x >= 0:
					player.velocity.x = move_toward(player.velocity.x, -player.running_speed, player.air_friction * delta)
				else:
					player.velocity.x = move_toward(player.velocity.x, -player.running_speed, player.acceleration * delta)
				player.move_direction = -1

			else:
				player.velocity.x = move_toward(player.velocity.x, 0, player.air_friction * delta)

		if Input.is_action_just_pressed("jump"):
			if not coyote_timer.is_stopped():
				player.velocity.y = player.jump_height
				player.jump_sfx.play()
				player.animation.start("jump")
				player.jump_particles()
				return

			elif coyote_timer.is_stopped() and player.can_double_jump and player.double_jump_enabled:
				player.can_double_jump = false
				if player.used_spring:
					player.used_spring = false
				player.velocity.y = player.jump_height
				player.jump_sfx.play()
				player.animation.start("double_jump")
				player.jump_particles()
				return
				
			if jump_buffer.is_stopped():
				jump_buffer.start()

		if player.wall_detect.is_colliding() and not player.ledge_detect.is_colliding() and player.wall_snap_raycast.is_colliding() and player.ledge_grab_enabled and player.ledge_cooldown.is_stopped():
			transitioned.emit(self, "Ledge Grab")
			return

		if player.is_on_wall() and player.wall_detect.is_colliding() and player.wall_slide_enabled:
			if not player.jump_buffer_timer.is_stopped():
				player.velocity.y = player.wall_jump_height
				player.velocity.x = player.wall_jump_push * player.move_direction
				player.is_jumping = true
				player.can_double_jump = true
				player.move_direction *= -1
				player.animation.start("jump")
				player.wall_jump_particles()
				player.jump_sfx.play()
				jump_buffer.stop()
				return
			
			transitioned.emit(self, "Wall Slide")
			return
		
		if Input.is_action_just_pressed("airdash") and player.air_dash_enabled and player.air_dashes_left > 0 and player.air_dash_cooldown_timer.is_stopped():
			player.get_air_dash_direction()
			player.velocity.x = player.air_dash_speed * player.dash_direction.x
			player.velocity.y = player.air_dash_speed * player.dash_direction.y
			player.animation.start("air_dash")
			transitioned.emit(self, "Air Dash")
			return

	else:
		if not jump_buffer.is_stopped():
			player.velocity.y = player.jump_height
			player.animation.start("jump")
			player.jump_sfx.play()
			player.can_double_jump = true
			jump_buffer.stop()
			player.jump_particles()
			if player.used_spring:
				player.used_spring = false
			return
		else:
			player.is_jumping = false
			coyote_timer.stop()
			transitioned.emit(self, "Idle")


func spawn_upwards_particles(delta):
	if player.velocity.y < -120:
		particle_timer += delta
		if particle_timer >= particle_timer_interval:
			particle_timer = 0.0
			player.upwards_particles()
