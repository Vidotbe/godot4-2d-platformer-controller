extends Button

@export var price = 0

@export var hud = CanvasLayer

@export var tuner : CanvasLayer = null

@export var category_name : String = "null"

@onready var label : RichTextLabel = $Label

@export var money_icon_path : String = "res://assets/ui/icons/moneyicon.png"

# Called when the node enters the scene tree for the first time.
func _ready():
	if PlayerData.sandbox_mode:
		queue_free()
		return

	var raw_text = "%s # %d" % [category_name, price]

	var money_icon = "[img=8]%s[/img]" % [money_icon_path]

	var formatted_text = raw_text.replace("#", money_icon)

	label.text = formatted_text


func _on_pressed():
	if hud.money_count >= price:
		hud.money_count -= price
		hud.update_ui()
		tuner.add_category(category_name)
		hud.buy_sfx.play()
		EventBus.emit_signal("skill_bought")
		queue_free()
