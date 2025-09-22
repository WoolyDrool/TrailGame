class_name PlayerUIPanel
extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func enter_panel() -> void:
	visible = true
	pass

func process_panel(_delta) -> void:
	pass

func exit_panel() -> void:
	visible = false
	pass
