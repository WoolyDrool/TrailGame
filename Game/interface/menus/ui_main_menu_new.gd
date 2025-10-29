class_name UIMainMenu
extends Control

@export var tween_time : float = 1
@export var positions_container : Control
var pos_1 : Vector2 = Vector2(0,0)
var pos_2 : Vector2 = Vector2(-1920,0)
var pos_3 : Vector2 = Vector2(-3840,0)
var pos_4 : Vector2 = Vector2(1920,0)
var pos_5 : Vector2 = Vector2(0, -1080)

signal new_game_started

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#region Tween Functions
func _on_play_button_pressed() -> void:
	var play_tween = get_tree().create_tween()
	play_tween.tween_property(positions_container, "position", pos_2, tween_time)

func _on_ss_back_button_pressed() -> void:
	var ss_back_tween = get_tree().create_tween()
	ss_back_tween.tween_property(positions_container, "position", pos_1, tween_time)

func _on_ds_back_button_pressed() -> void:
	var ds_back_tween = get_tree().create_tween()
	ds_back_tween.tween_property(positions_container, "position", pos_2, tween_time)

func _on_options_button_pressed() -> void:
	var options_tween = get_tree().create_tween()
	options_tween.tween_property(positions_container, "position", pos_4, tween_time)
	
func _on_quit_button_pressed() -> void:
	var quit_button_tween = get_tree().create_tween()
	quit_button_tween.tween_property(positions_container, "position", pos_5, tween_time)

func _on_opt_back_button_pressed() -> void:
	var opt_back_tween = get_tree().create_tween()
	opt_back_tween.tween_property(positions_container, "position", pos_1, tween_time)
	
func _on_no_quit_button_pressed() -> void:
	var no_quit_button_tween = get_tree().create_tween()
	no_quit_button_tween.tween_property(positions_container, "position", pos_1, tween_time)
#endregion

func _on_yes_quit_button_pressed() -> void:
	pass # Replace with function body.


# Start The Game
func _on_start_button_pressed() -> void:
	var fade_tween = get_tree().create_tween()
	fade_tween.tween_property(self, "modulate", Color(255,255,255,0), 1.5)
	new_game_started.emit()
