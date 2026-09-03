extends State


# Called when the node enters the scene tree for the first time.
func enter():
	if player.sprite:
		player.sprite.play("idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func physics_update(_delta):
	if not player.is_on_floor():
		transitioned.emit(self, "Fall")
		return
	
	if Input.is_action_just_pressed("jump"):
		player.velocity.y = player.jump_height
		transitioned.emit(self, "Fall")
		return

	if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		transitioned.emit(self, "Run")
