extends State

var travel_speed = 500
var respawn_speed = 10.0


func _ready():
	EventBus.start_challenge.connect(speed_up)

func speed_up():
	travel_speed = 1000

func enter():
	player.set_collision_layer_value(1, false)
	player.set_collision_mask_value(2, false)

func exit():
	player.set_collision_layer_value(1, true)
	player.set_collision_mask_value(2, true)

func physics_update(delta):
	check_flight_direction()
	
	if not player.visible:
			player.global_position = player.global_position.lerp(player.fast_travel_target, respawn_speed * delta)
	else:
		player.global_position = player.global_position.move_toward(player.fast_travel_target, travel_speed * delta)
	
	if player.global_position.distance_to(player.fast_travel_target) < 0.5:
		if PlayerData.in_challenge:
			if PlayerData.challenge_start:
				player.is_travelling = false
				if not player.visible:
					player.respawn_effect()
					if player.active_key:
						player.active_key.show()
				transitioned.emit(self, "Fall")
				PlayerData.challenge_start = false
		else:
			player.is_travelling = false
			if not player.visible:
				player.respawn_effect()
				if player.active_key:
					player.active_key.show()
			transitioned.emit(self, "Fall")

func check_flight_direction():
	if player.fast_travel_target.y < player.global_position.y:
		player.animation.travel("fast_travel_up")
	else:
		player.animation.travel("fast_travel_down")
