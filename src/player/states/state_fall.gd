extends State

@onready var coyote_timer = $Coyote_Time
@onready var jump_buffer = $Jump_Buffer

func _ready():
	await owner.ready
	if player:
		coyote_timer.wait_time = player.coyote_time
		jump_buffer.wait_time = player.jump_buffer_time

func enter():
	if not player.is_jumping:
		coyote_timer.start()

func exit():
	pass

func physics_update(delta):
	if not player.is_on_floor():
		player.velocity.y = move_toward(player.velocity.y, player.fall_speed, player.gravity * delta)
		if player.velocity.y > player.downward_fall_animation:
			player.animation.travel("fall")
		if not Input.is_action_pressed("jump") and player.velocity.y < player.downward_fall_animation:
			player.velocity.y += player.player_variable_jump_brake * delta

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
				player.animation.start("jump")
				return
			if jump_buffer.is_stopped():
				jump_buffer.start()

	else:
		if not jump_buffer.is_stopped():
			player.velocity.y = player.jump_height
			player.animation.start("jump")
			return
		else:
			player.is_jumping = false
			coyote_timer.stop()
			transitioned.emit(self, "Idle")
