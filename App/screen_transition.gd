class_name GlobalTransition
extends ColorRect

signal transition_finished
signal transition_started
@export var speed : float = 3.33

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func tween_in(custom_speed : float):
	var tween = get_tree().create_tween()
	transition_started.emit()
	tween.tween_property(self, "color", Color(0, 0, 0, 0), custom_speed)
	
func tween_out(custom_speed : float):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "color", Color(0, 0, 0, 1), custom_speed)
	await tween.finished
	transition_finished.emit()
