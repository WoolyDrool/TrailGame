extends PlayerUIPanel

@export_category("Elements")
@export var zone_name_label : RichTextLabel
@export var zone_data_label : RichTextLabel
@export var mission_thumbnail : TextureRect
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_button_pressed() -> void:
	GameManager.ui_hide_mission_panel.emit()
