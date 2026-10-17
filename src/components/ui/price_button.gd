extends Button

@export var price = 0

@export var hud = CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	text = str(price)


func _on_pressed():
	if hud.money_count >= price:
		hud.money_count -= price
		hud.update_ui()
		hud.buy_sfx.play()
		EventBus.emit_signal("skill_bought")
		queue_free()
