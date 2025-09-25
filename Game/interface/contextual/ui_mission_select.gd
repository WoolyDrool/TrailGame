class_name UIMissionSelect
extends PlayerUIPanel

@export_category("Elements")
@export var zone_name_label : RichTextLabel
@export var zone_data_label : RichTextLabel
@export var mission_thumbnail : TextureRect
@export var mission_vbox : VBoxContainer
@export var mission_select_button_scene : PackedScene

var selected_mission_name : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.ui_populate_mission_buttons.connect(populate_mission_buttons)
	GameManager.ui_hide_mission_panel.connect(depopulate_mission_buttons)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func populate_mission_buttons(mission_name : String):
	var new_button : UIMissionSelectButton = mission_select_button_scene.instantiate()
	new_button.text = mission_name
	new_button.assoc_mission_name = mission_name
	new_button.parent = self
	mission_vbox.add_child(new_button)

func _on_back_button_pressed() -> void:
	GameManager.ui_hide_mission_panel.emit()

func depopulate_mission_buttons():
	for child in mission_vbox.get_children():
		mission_vbox.remove_child(child)
		child.queue_free()

func select_mission(mission_name : String):
	selected_mission_name = mission_name

func start_selected_mission():
	pass

func _on_start_button_pressed() -> void:
	if selected_mission_name != null:
		GameManager.mission_attempt_to_start.emit(selected_mission_name)
		depopulate_mission_buttons()
	else:
		push_error("No mission is selected")
