extends CharacterBody3D

class_name Player

enum PLAYER_STATES {IDLE, WALKING, JUMPING, FALLING, TOUCHDOWN, CROUCHING, MENU, CONVERSATION, CUTSCENE, TELEPORTING, PICKERJUMP}
@export var player_state : PLAYER_STATES

# Nodes
@export var cam_container : Node3D
@onready var standing_collision = $StandingCollision
@onready var crouching_collision = $CrouchingCollision
@onready var ceiling_check = $CeilingCheck
@onready var health_manager = $PlayerHealthManager
@onready var debug_label = $DebugUI/RichTextLabel
@onready var debug_label_2 = $DebugUI/RichTextLabel2

@export_category("Mouse Look")
@export var mouse_sens : float = 0.4
@export var mouse_smoothing : bool = true
@export var mouse_lerp_speed : float = 20

# Movement
@export_category("Main Movement")
var current_speed : float = 5.0
@export var walking_speed : float  = 5
@export var sprinting_speed : float  = 8
@export var crouching_speed : float  = 2.5
@export var move_lerp_speed : float = 10
@export var is_moving : bool = false
@export var fall_damage_threshhold : float = 20
var prev_velocity : float

@export_category("Jumping")
@export var jump_velocity : float  = 4.5
@export var gravity_accel_ramp : float = 1
@export var grav_multiplier : float = -1
@export var bunny_multiplier : float = 1
@export var bunny_deaccell : float = 0.24
@export var bunny : bool = true

#region Internal Variables
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var input_dir
var direction = Vector3.ZERO

var can_move : bool = true
var can_use_mouse : bool = true
var was_on_floor : bool = true
var has_picker_jumped : bool = false
var is_looking_down : bool = false

var crouch_tween : Tween
var default_cam_height = Vector3(0, 1, 0)
var crouched_cam_height = Vector3(0, 0, 0)
var crouch_transition_speed : float = 0.55
var stand_transition_speed : float = 0.2
#endregion

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	GameManager.player_move_to_position.connect(teleport_player)
	GameManager.player_seize_controls.connect(seize_controls)
	GameManager.player_return_controls.connect(return_controls)
	GameManager.player_show_mouse.connect(toggle_mouse_state)
	debug_label.text = str("state: none")

#region Player Game State Functions
func seize_controls():
	can_move = false
	can_use_mouse = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func return_controls():
	can_move = true
	can_use_mouse = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func teleport_player(newpos : Vector3):
	self.position = newpos
	pass

func toggle_mouse_state(boolean : bool):
	print("toggled mouse state")
	if boolean:
		can_use_mouse = false
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		can_use_mouse = true
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
#endregion

func _input(event):
	if can_use_mouse:
		if event is InputEventMouseMotion:
			rotate_y(deg_to_rad(-event.relative.x) * mouse_sens)
			cam_container.rotate_x(deg_to_rad(-event.relative.y) * mouse_sens)
			cam_container.rotation.x = clamp(cam_container.rotation.x, deg_to_rad(-89), deg_to_rad(89))
			if cam_container.rotation.x <= deg_to_rad(-69):
				is_looking_down = true
				debug_label_2.text = "ild = true"
			else:
				is_looking_down = false
				debug_label_2.text = "ild = false"

func _process(delta):
	pass
	#if Input.is_action_just_pressed("ui_cancel") && Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	#elif Input.is_action_just_pressed("primary") && Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	if !health_manager.dead:
		handle_states(delta)
		determine_move_speed()
	#handle_jump_input()
	#
	#apply_gravity(delta)
	#handle_movement(delta)

#region State Logic 

#region State Machine
func change_state(new_state : PLAYER_STATES) -> void:
	if !can_move:
		return
	if new_state == player_state:
		return
	player_state = new_state
	
func handle_states(_delta) -> void:
	if !can_move:
		return
	match player_state:
		PLAYER_STATES.IDLE:
			state_idle(_delta)
			debug_label.text = str("state: Idle")
		PLAYER_STATES.WALKING:
			state_walk(_delta)
			debug_label.text = str("state: Walk")
		PLAYER_STATES.JUMPING:
			state_jump(_delta)
			debug_label.text = str("state: Jumping")
		PLAYER_STATES.PICKERJUMP:
			state_pickerJump(_delta)
			debug_label.text = str("state: Picker Jumping")
		PLAYER_STATES.FALLING:
			debug_label.text = str("state: Falling")
			state_falling(_delta)
		PLAYER_STATES.TOUCHDOWN:
			debug_label.text = str("state: Touchdown")
			state_touchdown(_delta)
		PLAYER_STATES.CONVERSATION:
			debug_label.text = str("state: Conversation")
			state_conversation()
#endregion

func check_if_on_floor():
	if !is_on_floor():
		change_state(PLAYER_STATES.FALLING)

#region States
func state_idle(_delta):
	handle_movement_input(_delta)
	if not is_on_floor():
		change_state(PLAYER_STATES.FALLING)	
	if input_dir.length() > 0:
		change_state(PLAYER_STATES.WALKING)	
	handle_jump_input()

func state_walk(_delta):
	#print("in walking state")
	handle_movement_input(_delta)
	handle_movement(_delta)
	handle_jump_input()
	if not is_on_floor():
		change_state(PLAYER_STATES.FALLING)	
	if input_dir.length() <= 0:
		change_state(PLAYER_STATES.IDLE)

func state_jump(_delta):
	#print("in jumping state")
	handle_movement_input(_delta)
	handle_movement(_delta)
	handle_jump_input()
	if velocity.y < jump_velocity:
		change_state(PLAYER_STATES.FALLING)

func state_pickerJump(_delta):
	has_picker_jumped = true
	handle_movement_input(_delta)
	handle_movement(_delta)
	velocity.y = jump_velocity * 2
	if velocity.y < jump_velocity * 2:
		change_state(PLAYER_STATES.FALLING)
		
func state_falling(_delta):
	#print("in falling state")
	if is_on_floor():
		change_state(PLAYER_STATES.TOUCHDOWN)
	handle_movement_input(_delta)
	handle_movement(_delta)

func state_touchdown(delta):
	print("touched down with a velocity of ", prev_velocity)
	if prev_velocity <= fall_damage_threshhold:
		print("player died from fall damage!")
		GameManager.player_death.emit()
		seize_controls()
	else:
		print("safely landed")
		has_picker_jumped = false
		change_state(PLAYER_STATES.IDLE)
		
func state_conversation():
	pass
#endregion

#endregion

#region Transformation Functions
func handle_movement_input(_delta):
	input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back").normalized()
	direction = lerp(direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), _delta * move_lerp_speed)
	pass
	# Get the input direction and handle the movement/deceleration.

func handle_movement(_delta):
	apply_gravity(_delta)
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
	
	move_and_slide()

func determine_move_speed():
	# Determine movement speed
	if Input.is_action_pressed("move_crouch"):
		current_speed = crouching_speed
		standing_collision.disabled = true
		crouching_collision.disabled = false
		var tween = get_tree().create_tween()
		tween.tween_property(cam_container, "position", crouched_cam_height, crouch_transition_speed)
	else:
		standing_collision.disabled = false
		crouching_collision.disabled = true
		if Input.is_action_pressed("move_sprint"):
			current_speed = sprinting_speed
		else:
			current_speed = walking_speed
	
	if Input.is_action_just_released("move_crouch"):
		var tween = get_tree().create_tween()
		tween.tween_property(cam_container, "position", default_cam_height, crouch_transition_speed)

func handle_jump_input():
	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		velocity.y = jump_velocity
		change_state(PLAYER_STATES.JUMPING)
		
func apply_gravity(_delta):
		# Add the gravity.
	if not is_on_floor():
		var deaccell_ramp = lerpf(0, grav_multiplier, gravity_accel_ramp)
		velocity.y -= (gravity - deaccell_ramp) * _delta 	
		prev_velocity = velocity.y
		
func bunny_hop(_delta):
	if bunny:
		if Input.is_action_just_pressed("move_jump") and Input.is_action_pressed("move_forward"):
			print("Bunny!")
			var speedbonus = current_speed + bunny_multiplier
			var actual_speedbonus = lerpf(speedbonus, current_speed, bunny_deaccell)
			current_speed = actual_speedbonus
#endregion
