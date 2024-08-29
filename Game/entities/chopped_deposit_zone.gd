extends Area3D

@export var mission : AreaMission

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_shape_entered(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	if body is RigidBody3D:
		if body.is_in_group("choppable"):
			mission.complete_objective(1)
			GameManager.ui_update_item_counts.emit()
			GameManager.ui_update_score_count.emit(mission)
			body.queue_free()
