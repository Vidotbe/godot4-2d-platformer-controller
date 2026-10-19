extends State

var travel_speed = 500


func enter():
	player.set_collision_layer_value(1, false)
	player.set_collision_mask_value(2, false)

func exit():
	player.set_collision_layer_value(1, true)
	player.set_collision_mask_value(2, true)

func physics_update(delta):
	check_flight_direction()
	
	
	player.global_position = player.global_position.move_toward(player.fast_travel_target, travel_speed * delta)
	
	if player.global_position.distance_to(player.fast_travel_target) < 0.5:
		player.is_travelling = false
		transitioned.emit(self, "Fall")


func check_flight_direction():
	if player.fast_travel_target.y < player.global_position.y:
		player.animation.travel("fast_travel_up")
	else:
		player.animation.travel("fast_travel_down")
