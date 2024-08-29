extends Node3D

@export var rigidbody : RigidBody3D
@export var interact : InteractComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_grab():
	interact.set_process(false)

func on_throw():
	interact.set_process(true)
