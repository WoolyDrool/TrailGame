extends State

class_name PlayerIdle

@export var ps : PlayerState

func update(delta):
	if ps.input_dir.x > 0 || ps.input_dir.y:
		transitioned.emit(self, "moving")
	
