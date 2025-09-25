class_name PlayerUIPanel
extends Control

@export var mouse_visible : bool = false
@export var player_controls : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func enter_panel() -> void:
	visible = true
	if mouse_visible:
		GameManager.player_show_mouse.emit(true)
	else:
		GameManager.player_show_mouse.emit(false)
		
	if !player_controls:
		GameManager.player_seize_controls.emit()

func process_panel(_delta) -> void:
	pass

func exit_panel() -> void:
	if mouse_visible:
		GameManager.player_show_mouse.emit(false)
	else:
		GameManager.player_show_mouse.emit(true)
	
	if !player_controls:
		GameManager.player_return_controls.emit()
	
	visible = false
	pass
