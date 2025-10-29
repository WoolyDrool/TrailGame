class_name UISaveFileButton
extends Control

@export var assoc_button : Button
@export var save_index : int = 0
@export var assoc_save_file : PlayerSaveData

@onready var select_button : Button = $SelectButton
@onready var delete_confirm_box : Control = $ConfirmDelete
@onready var options_box : HBoxContainer = $Options

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	select_button.visible = true
	delete_confirm_box.visible = false
	options_box.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_button_pressed() -> void:
	pass # Replace with function body.

func _on_delete_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		select_button.visible = false
		delete_confirm_box.visible = true
	else:
		select_button.visible = true
		delete_confirm_box.visible = false

# Delete Confirmation
func _on_yes_button_pressed() -> void:
	pass # Replace with function body.

func _on_no_button_pressed() -> void:
	select_button.visible = true
	delete_confirm_box.visible = false
	_on_delete_button_toggled(false)


func _on_select_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		if assoc_save_file:
			options_box.visible = true
	else:
		options_box.visible = false

func _on_select_button_pressed() -> void:
	pass # Replace with function body.
