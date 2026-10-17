extends Button

@export var slider : HSlider = null
@export var tuner : CanvasLayer = null
@export var minus_button : Button = null

var times_clicked : float = 0

@export var cost  = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("plus_buttons")

func _process(_delta):
	if times_clicked > 0:
		$Label.text = str(times_clicked)
		slider.modulate.s = times_clicked / 40
	elif times_clicked == 0 and minus_button.times_clicked == 0:
		slider.modulate.s = 0
		$Label.text = ""
	else:
		$Label.text = ""

func reset_times_clicked():
	times_clicked = 0

func _on_pressed():
	if minus_button.times_clicked > 0:
		minus_button.times_clicked -= cost
		slider.value += slider.step
		tuner.capacity_used -= cost

		tuner.edit_sfx.play()
		if minus_button.times_clicked != 0:
			tuner.edit_sfx.pitch_scale = minus_button.times_clicked / 20
	else:
		if slider.value < slider.max_value and tuner.maximum_capacity >= tuner.capacity_used + cost:
			tuner.capacity_used += cost
			times_clicked += cost
			slider.value += slider.step

			tuner.edit_sfx.play()
			tuner.edit_sfx.pitch_scale = times_clicked / 20
		else:
			tuner.denied_sfx.play()

	tuner.update_capacity()
