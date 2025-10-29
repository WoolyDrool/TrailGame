extends Control

@export var main_menu : UIMainMenu

@export var save_1 : UISaveFileButton
@export var save_2 : UISaveFileButton
@export var save_3 : UISaveFileButton
@export var save_4 : UISaveFileButton

func _ready() -> void:
	save_1.assoc_button.pressed.connect(save_1_select)
	save_2.assoc_button.pressed.connect(save_2_select)
	save_3.assoc_button.pressed.connect(save_3_select)
	save_4.assoc_button.pressed.connect(save_4_select)
	
func save_1_select():
	var save_1_select_tween = get_tree().create_tween()
	save_1_select_tween.tween_property(main_menu.positions_container, "position", main_menu.pos_3, main_menu.tween_time)
	save_1.assoc_button.button_pressed = false

func save_2_select():
	var save_2_select_tween = get_tree().create_tween()
	save_2_select_tween.tween_property(main_menu.positions_container, "position", main_menu.pos_3, main_menu.tween_time)
	save_2.assoc_button.button_pressed = false
	
func save_3_select():
	var save_3_select_tween = get_tree().create_tween()
	save_3_select_tween.tween_property(main_menu.positions_container, "position", main_menu.pos_3, main_menu.tween_time)
	save_3.assoc_button.button_pressed = false
	
func save_4_select():
	var save_4_select_tween = get_tree().create_tween()
	save_4_select_tween.tween_property(main_menu.positions_container, "position", main_menu.pos_3, main_menu.tween_time)
	save_4.assoc_button.button_pressed = false


func _on_ss_back_button_pressed() -> void:
	save_1.assoc_button.button_pressed = false
	save_2.assoc_button.button_pressed = false
	save_3.assoc_button.button_pressed = false
	save_4.assoc_button.button_pressed = false
