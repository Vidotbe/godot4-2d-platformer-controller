extends Button

@export var slider : HSlider = null
@export var tuner : CanvasLayer = null
@export var plus_button : Button = null

var times_clicked : float = 0

@export var cost = 1


func _ready():
	add_to_group("minus_buttons")

func _process(_delta):
	if times_clicked > 0:
		$Label.text = str(times_clicked)
		slider.modulate.s = times_clicked / 40
	else:
		$Label.text = ""

func reset_times_clicked():
	times_clicked = 0

func _on_pressed():
	if plus_button.times_clicked > 0:
		plus_button.times_clicked -= cost
		slider.value -= slider.step
		tuner.capacity_used -= cost
		tuner.edit_sfx.play()
		if plus_button.times_clicked != 0:
			tuner.edit_sfx.pitch_scale = plus_button.times_clicked / 20
	else:
		if slider.value > slider.min_value and tuner.maximum_capacity >= tuner.capacity_used + cost:
			tuner.capacity_used += cost
			times_clicked += cost
			slider.value -= slider.step
			tuner.edit_sfx.play()
			tuner.edit_sfx.pitch_scale = times_clicked / 20
		else:
			tuner.denied_sfx.play()

	tuner.update_capacity()

	
	
