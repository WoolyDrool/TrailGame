class_name UIMissionSelectButton
extends CheckButton

var parent : UIMissionSelect
var assoc_mission_name : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_pressed() -> void:
	parent.select_mission(assoc_mission_name)
