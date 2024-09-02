extends Node3D

var y_offset : float = 0.1
@export var dirt_model : Node3D
var progress : int = 0
var progress_max : int = 3
@export var buried_item : ObjectiveItem

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	buried_item.position.y -= y_offset * (progress_max * 0.1)
	buried_item.disable_process()

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_dig():
	if progress < progress_max:
		dirt_model.position.y -= y_offset
		buried_item.position.y += y_offset
		progress += 1
		if progress == progress_max:
			buried_item.reparent(get_parent())
			buried_item.enable_process()
			queue_free()
