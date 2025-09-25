class_name ImmediateUI
extends Control

@export var context_panel : Control
@export var immediate_ui_active : bool = false
@export var frobber : Frobber

@export_category("Labels")
@export var interact_text : Label
@export var key_input_text : Label
@export var descriptor_text : Label
@export var context_text : Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	context_panel.visible = false
	immediate_ui_active = false
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_immediate_ui(context_obj : InteractComponent):
	if context_obj:
		interact_text.text = context_obj.interactText
		descriptor_text.text = context_obj.descriptorText
		context_text.text = context_obj.contextText
		
		interact_text.add_theme_color_override("font_color", context_obj.interactText_Color)
		descriptor_text.add_theme_color_override("font_color", context_obj.descriptorText_Color)
		context_text.add_theme_color_override("font_color", context_obj.contextText_Color)
		context_panel.visible = true
		immediate_ui_active = true

func clear_immediate_ui():
	interact_text.text = ""
	descriptor_text.text = ""
	context_text.text = ""
	context_panel.visible = false
	immediate_ui_active = false
