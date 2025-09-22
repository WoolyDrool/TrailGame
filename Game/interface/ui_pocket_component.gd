extends TextureProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.ui_update_item_counts.connect(update_ui)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_ui():
	if value <= (value / 2):
		modulate = Color.WHITE
	elif value > (value / 2):
		modulate = Color.ORANGE
	elif value == max_value:
		modulate = Color.FIREBRICK	
	
	
