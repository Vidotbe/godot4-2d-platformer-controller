extends GPUParticles2D

@onready var secondary_particle = $GPUParticles2D

# Called when the node enters the scene tree for the first time.
func _ready():
	emitting = true
	if secondary_particle:
		secondary_particle.emitting = true

func _on_finished():
	queue_free()
