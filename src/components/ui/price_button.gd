extends Button

@export var price = 0

@export var hud = CanvasLayer

@export var tuner : CanvasLayer = null

@export var category_name : String = "null"

# Called when the node enters the scene tree for the first time.
func _ready():
	if PlayerData.sandbox_mode:
		queue_free()
		return

	text = str(price)


func _on_pressed():
	if hud.money_count >= price:
		hud.money_count -= price
		hud.update_ui()
		tuner.add_category(category_name)
		hud.buy_sfx.play()
		EventBus.emit_signal("skill_bought")
		queue_free()
