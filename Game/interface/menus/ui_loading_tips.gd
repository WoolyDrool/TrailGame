extends Node

@export var tips : Dictionary[String, Texture2D]
@export var loading_tip_label : Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	select_random_tip()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func select_random_tip():
	var rand_tip = tips.keys().pick_random()
	loading_tip_label.text = str("Tip: " + rand_tip)
