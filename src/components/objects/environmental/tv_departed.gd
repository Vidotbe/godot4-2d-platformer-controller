extends Node2D

@onready var time : Label = $Time
@onready var departed_time : Label = $Departed


# Called when the node enters the scene tree for the first time.
func _ready():
	var departure_time = Time.get_time_dict_from_system()
	var hour_offset = randi_range(1,5)
	var minute_offset = randi_range(6,47)
	var adjusted_hour = (departure_time.hour - hour_offset) % 24
	var adjusted_minute = (departure_time.minute - minute_offset) % 60
	if adjusted_hour < 0:
		adjusted_hour += 24
	
	if adjusted_minute < 0:
		adjusted_minute += 60
	
	departed_time.text = "Departure "+"%02d:%02d" % [adjusted_hour, adjusted_minute]


func _on_timer_timeout():
	var current_time = Time.get_time_dict_from_system()
	time.text = "%02d:%02d" % [current_time.hour, current_time.minute]
