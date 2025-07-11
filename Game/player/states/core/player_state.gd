class_name PlayerState
extends State


@export var animation_name : String

@export_category("Look Settings")
@export var has_mouse_control : bool = true
@export var has_mouse_visible : bool = false
@export var mouse_sensitivity : float = 2

@export_category("Movement - Main Controls")
@export var move_speed : float = 0
@export var movement_vector : Vector2
@export var movement_direction : Vector3

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Hold a reference to the player so that it can be controlled by the state
var player : PlayerSMC

func enter() -> void:
	super()

func exit() -> void:
	super()

func process_input(_event : InputEvent) -> PlayerState:
	#if has_mouse_control:
		#if _event is InputEventMouseMotion:
			#player.rotate_y(deg_to_rad(-_event.relative.x) * mouse_sensitivity)
			#player.cam_container.rotate_x(deg_to_rad(-_event.relative.y) * mouse_sensitivity)
			#player.cam_container.rotation.x = clamp(player.cam_container.rotation.x, deg_to_rad(-89), deg_to_rad(89))
	return null

func process_frame(_delta : float) -> PlayerState:
	return null

func process_physics(_delta : float) -> PlayerState:	
	movement_vector = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	movement_direction = (player.transform.basis * Vector3(movement_vector.x, player.velocity.y, movement_vector.y)).normalized() * _delta
	return null
