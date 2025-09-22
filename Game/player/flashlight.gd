class_name PlayerFlashlight
extends Node3D

@export var cam_container : Node3D
@export var player_joint : Node3D
@export var cam_joint : Node3D

@onready var light = $PlayerJoint/CamJoint/SpotLight3D

@export var lerp_speed : float = 2.1
var current_rotation : Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("tertiary"):
		if light.visible:
			light.visible = false
		else:
			light.visible = true
