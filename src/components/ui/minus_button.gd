extends Button

@export var slider : HSlider = null
@export var tuner : CanvasLayer = null
@export var plus_button : Button = null

var times_clicked : float = 0

@export var cost = 1

var button_held = false
var held_timer = 0.0

var hold_limit = 0.2

var hold_limit_threshold = 0.1

var start_loop = false

func _ready():
	add_to_group("minus_buttons")
	button_down.connect(on_button_down)
	button_up.connect(on_button_up)

func _process(delta):
	if times_clicked > 0:
		$Label.text = str(times_clicked)
		slider.modulate.s = times_clicked / 40
	else:
		$Label.text = ""

	if button_held:
		held_timer += delta
		if held_timer >= hold_limit:
			_on_held()
			held_timer = 0.0
			start_loop = true
			if hold_limit >= hold_limit_threshold:
				hold_limit -= 0.05

func reset_times_clicked():
	times_clicked = 0

func _on_pressed():
	if not start_loop:
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


func _on_held():
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
	
func on_button_down():
	button_held = true
	held_timer = 0.0
	hold_limit = 0.5
	start_loop = false

func on_button_up():
	button_held = false
