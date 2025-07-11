class_name PlayerSMC
extends CharacterBody3D

@export var state_debug_label : RichTextLabel
@export var vector_debug_label : RichTextLabel
@export var direction_debug_label : RichTextLabel

@export_group("Global Movement Variables")
@export var default_movement_speed = 250
@export var jump_height : float = 350

# Nodes
@export_group("Nodes")
@export var cam_container : Node3D
@export var standing_collision : CollisionShape3D
@export var crouching_collision : CollisionShape3D
@export var ceiling_check : RayCast3D

@export var state_machine : StateMachine


func _ready() -> void:
	state_machine.init(self)
	state_machine.s_player_updateMouseState.connect(update_mouse_state)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)
	
func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	
func _process(delta: float) -> void:
	state_machine.process_frame(delta)
	state_debug_label.text = str("state: ", state_machine.current_state.name)
	vector_debug_label.text = str("vector: ", state_machine.current_state.movement_vector)
	direction_debug_label.text = str("direction: ", state_machine.current_state.movement_direction)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x) * GameManager.mouse_sensitivity)
		cam_container.rotate_x(deg_to_rad(-event.relative.y) * GameManager.mouse_sensitivity)
		cam_container.rotation.x = clamp(cam_container.rotation.x, deg_to_rad(-89), deg_to_rad(89))

func update_mouse_state(has_mouse_control : bool):
	if has_mouse_control:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
