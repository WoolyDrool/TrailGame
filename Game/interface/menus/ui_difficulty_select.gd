extends Control

@export var normal_description : Control
@export var hardcore_description : Control
@export var fade_tween_speed : float = 0.15
@export var start_game_button : Button

@export var is_hardcore_selected : bool = false
@export var any_difficulty_selected : bool = false
@export var warning_label : Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	warning_label.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if any_difficulty_selected:
		if !start_game_button.visible:
			start_game_button.visible = true
		
		if !warning_label.visible:
			warning_label.visible = true
	pass

func _on_normal_difficulty_button_mouse_entered() -> void:
	normal_description.visible = true
	hardcore_description.visible = false

func _on_normal_difficulty_button_mouse_exited() -> void:
	normal_description.visible = false
	
func _on_hc_difficulty_button_mouse_entered() -> void:
	normal_description.visible = false
	hardcore_description.visible = true
	
func _on_hc_difficulty_button_mouse_exited() -> void:
	hardcore_description.visible = false

func _on_normal_difficulty_button_toggled(toggled_on: bool) -> void:
	is_hardcore_selected = false
	any_difficulty_selected = true 

func _on_hc_difficulty_button_toggled(toggled_on: bool) -> void:
	is_hardcore_selected = true
	any_difficulty_selected = true

func _on_ds_back_button_pressed() -> void:
	$VBoxContainer/NormalDifficultyButton.button_pressed = false
	$VBoxContainer/HCDifficultyButton.button_pressed = false
	any_difficulty_selected = false
	is_hardcore_selected = false
	start_game_button.visible = false
	warning_label.visible = false
