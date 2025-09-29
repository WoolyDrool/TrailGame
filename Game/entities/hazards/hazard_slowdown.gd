extends Node3D

@export var hazard_health : int = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_chop():
	print("called")
	hazard_health -= 1
	if hazard_health == 0:
		queue_free()
