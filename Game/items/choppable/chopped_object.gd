extends RigidBody3D

class_name ChoppedObject
@export var interact_component : InteractComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func disable_process():
	freeze = true
	interact_component.set_process(false)
	interact_component.visible = false
	interact_component.collision.disabled = true

func enable_process():
	freeze = false
	interact_component.set_process(true)
	interact_component.visible = true
	interact_component.collision.disabled = false
	
