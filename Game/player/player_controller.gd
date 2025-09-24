extends CharacterBody3D

class_name Player

enum PLAYER_STATES {IDLE, WALKING, JUMPING, FALLING, TOUCHDOWN, CROUCHING, MENU, CONVERSATION, CUTSCENE, TELEPORTING, PICKERJUMP}
@export var player_state : PLAYER_STATES

# Nodes
@export var cam_container : Node3D
@onready var camera_3d = $PhantomCamera3D
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

@export_category("Gamepad Look")
@export var controller_look_sens : float = 0.5

# Movement
@export_category("Main Movement")
@export var walking_speed : float  = 5
@export var sprinting_speed : float  = 8
@export var crouching_speed : float  = 2.5
@export var is_moving : bool = false
@export var ground_accel : float = 14
@export var ground_decel : float = 10 	# For the quake style movement, accel is 14, decel is 10, friction is 6
@export var ground_friction : float = 6

@export_category("Jumping and Air Movement")
@export var jump_velocity : float  = 4.5
@export var air_cap : float = 0.85
@export var air_accel : float = 800
@export var air_move_speed : float = 500

#region Internal Variables
var prev_velocity : float
var current_speed : float = 5.0

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var input_dir
var wish_dir
var direction = Vector3.ZERO

var can_move : bool = true
var can_use_mouse : bool = true
var was_on_floor : bool = true
var has_picker_jumped : bool = false
var is_looking_down : bool = false
var cur_controller_look : Vector2

var fall_damage_threshhold : float = -20

var crouch_tween : Tween
var default_cam_height = Vector3(0, 1, 0)
var crouched_cam_height = Vector3(0, 0, 0)
var crouch_transition_speed : float = 0.55
var stand_transition_speed : float = 0.2

var headbob_amount : float = 0.06
var headbob_frequency : float = 2.4
var headbob_time : float 

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
			
			# Determine if looking down
			if cam_container.rotation.x <= deg_to_rad(-69):
				is_looking_down = true
				debug_label_2.text = "ild = true"
			else:
				is_looking_down = false
				debug_label_2.text = "ild = false"

func _handle_controller_look(_delta):
	var target_look : Vector2 = Input.get_vector("look_left", "look_right", "look_down", "look_up")
	cur_controller_look = target_look
	
	rotate_y(-cur_controller_look.x * controller_look_sens)
	cam_container.rotate_x(deg_to_rad(cur_controller_look.y) * controller_look_sens)
	cam_container.rotation.x = clamp(cam_container.rotation.x, deg_to_rad(-89), deg_to_rad(89))

func _process(delta):
	if can_use_mouse:
		if GameManager.controller_enabled:
			_handle_controller_look(delta) 

func _physics_process(delta):
	if !health_manager.dead:
		handle_states(delta)
		determine_move_speed()
	handle_jump_input()
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
	if not is_on_floor():
		change_state(PLAYER_STATES.FALLING)	
	handle_movement_input(_delta)
	if input_dir.length() > 0:
		change_state(PLAYER_STATES.WALKING)	
	handle_jump_input()
	
	handle_movement(_delta)
	

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
		if velocity.length() > 0:
			change_state(PLAYER_STATES.WALKING)
		else:
			change_state(PLAYER_STATES.IDLE)
		
func state_conversation():
	pass
#endregion

#endregion

#region Transformation Functions
#func apply_gravity(_delta):
		## Add the gravity.
	#if not is_on_floor():
		#var deaccell_ramp = lerpf(0, grav_multiplier, gravity_accel_ramp)
		#velocity.y -= (gravity - deaccell_ramp) * _delta 	
		#prev_velocity = velocity.y


func handle_movement_input(_delta):
	input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	wish_dir = transform.basis * Vector3(input_dir.x, 0, input_dir.y).normalized()

func handle_jump_input():
	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		velocity.y = jump_velocity
		change_state(PLAYER_STATES.JUMPING)

func _handle_ground_physics(_delta) -> void:
	#velocity.x = wish_dir.x * current_speed
	#velocity.z = wish_dir.z * current_speed
	
	var cur_speed_in_wish_dir = velocity.dot(wish_dir)
	var add_speed_til_cap = current_speed - cur_speed_in_wish_dir
	
	if add_speed_til_cap > 0:
		var accel_speed = ground_accel * _delta * current_speed
		accel_speed = min(accel_speed, add_speed_til_cap)
		velocity += accel_speed * wish_dir
	
	# Apply friction
	# I have no idea what is going on
	var control = max(velocity.length(), ground_decel)
	var drop = control * ground_friction * _delta
	var new_speed = max(velocity.length() - drop, 0.0)
	if velocity.length() > 0:
		new_speed /= velocity.length()
	
	velocity *= new_speed
	
	_headbob_effect(_delta)

func _handle_air_physics(_delta) -> void:
	velocity.y -= gravity * _delta
	
	# Weird quake-style nonsense involving a dot product
	var cur_speed_in_wish_dir = velocity.dot(wish_dir)
	var capped_speed = min((air_move_speed * wish_dir).length(), air_cap) 
	var add_speed_till_cap = capped_speed - cur_speed_in_wish_dir
	
	if add_speed_till_cap > 0:
		var accel_speed = air_accel * air_move_speed * _delta
		accel_speed = min(accel_speed, add_speed_till_cap)
		velocity += accel_speed * wish_dir

func handle_movement(_delta):
	if is_on_floor():
		_handle_ground_physics(_delta)
	else:
		_handle_air_physics(_delta)
	
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

func _headbob_effect(_delta):
	headbob_time += _delta * velocity.length()
	camera_3d.transform.origin = Vector3(
		cos(headbob_time * headbob_frequency * 0.5) * headbob_amount,
		default_cam_height.y + sin(headbob_time * headbob_frequency) * headbob_amount,
		0
	)
#endregion
