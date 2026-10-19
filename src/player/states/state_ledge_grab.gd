extends State

var grab_offset = 20
var getup_pos = Vector2(0,0)
var getting_up = false

func enter():
	if not player.just_died:
		getting_up = false
		getup_pos = Vector2(9 * player.move_direction, -20)
		
		player.force_update_transform()
		
		player.ledge_snap.force_raycast_update()

		
		if not player.ledge_snap.is_colliding() or not player.wall_detect.is_colliding():
			transitioned.emit(self, "Fall")
			return
		
		if player.wall_snap_raycast.target_position.x == 6 and player.move_direction == -1:
			transitioned.emit(self, "Fall")
			return

		elif player.wall_snap_raycast.target_position.x == -6 and player.move_direction == 1:
			transitioned.emit(self, "Fall")
			return


		var snap = player.ledge_snap.get_collision_point()
		var wall_snap = player.wall_snap_raycast.get_collision_point()

		player.global_position.y = snap.y + grab_offset
		player.global_position.x = wall_snap.x
		player.velocity = Vector2.ZERO
		player.animation.start("ledge_grab")
		player.ledgegrab_sfx.play()

func exit():
	pass

func physics_update(_delta):
	if not player.wall_detect.is_colliding() or not player.wall_snap_raycast.is_colliding():
		transitioned.emit(self, "Fall")
		return
	
	
	
	if player.just_died:
		transitioned.emit(self, "Idle")
		return

	if Input.is_action_just_pressed("up") and not getting_up:
		getting_up = true
		player.ledgegetup_sfx.play()
		player.animation.travel("ledge_get_up")
		player.camera.offset = getup_pos

	if Input.is_action_just_pressed("jump") and not getting_up:
		player.velocity.y = player.jump_height
		player.jump_sfx.play()
		player.is_jumping = true
		transitioned.emit(self, "Fall")
		player.animation.start("jump")
		player.ledge_cooldown.start()
		return

	if Input.is_action_just_pressed("down") and not getting_up:
		player.is_jumping = true
		transitioned.emit(self, "Fall")
		player.animation.start("jump")
		player.ledge_cooldown.start()
		return


	player.velocity = Vector2.ZERO


func _on_animation_tree_animation_finished(anim_name):
	if anim_name == "ledge_get_up":
		player.animation.travel("idle")
		await get_tree().process_frame
		player.global_position += getup_pos
		player.camera.offset.x = 0
		player.camera.offset.y = 0
		await get_tree().process_frame
		transitioned.emit(self, "Idle")
