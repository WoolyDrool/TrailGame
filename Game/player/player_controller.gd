extends CharacterBody3D

class_name Player

# Nodes
@export var cam_container : Node3D
@onready var standing_collision = $StandingCollision
@onready var crouching_collision = $CrouchingCollision
@onready var ceiling_check = $CeilingCheck

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

@export_category("Jumping")
@export var jump_velocity : float  = 4.5
@export var gravity_accel_ramp : float = 1
@export var grav_multiplier : float = -1
@export var bunny_multiplier : float = 1
@export var bunny_deaccell : float = 0.24
@export var bunny : bool = true

var can_move : bool = true
var can_use_mouse : bool = true

# Internal variables
var direction = Vector3.ZERO
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	GameManager.move_player_to_position.connect(teleport_player)
	GameManager.player_seize_controls.connect(seize_controls)
	GameManager.player_return_controls.connect(return_controls)
	seize_controls()
	await get_tree().create_timer(1).timeout
	return_controls()

func teleport_player(newpos : Vector3):
	self.position = newpos
	pass

func _input(event):
	if can_use_mouse:
		if event is InputEventMouseMotion:
			rotate_y(deg_to_rad(-event.relative.x) * mouse_sens)
			cam_container.rotate_x(deg_to_rad(-event.relative.y) * mouse_sens)
			cam_container.rotation.x = clamp(cam_container.rotation.x, deg_to_rad(-89), deg_to_rad(89))

func seize_controls():
	can_move = false
	can_use_mouse = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func return_controls():
	can_move = true
	can_use_mouse = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta):
	if can_move:
		determine_move_speed()
		
		handle_jump()
		
		if Input.is_action_just_pressed("ui_cancel") && Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		elif Input.is_action_just_pressed("primary") && Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	if can_move:
		apply_gravity(delta)
		
		bunny_hop(delta)
		
		handle_movement(delta)

func determine_move_speed():
	# Determine movement speed
	if Input.is_action_pressed("move_crouch"):
		current_speed = crouching_speed
		standing_collision.disabled = true
		crouching_collision.disabled = false
	else:
		standing_collision.disabled = false
		crouching_collision.disabled = true
		if Input.is_action_pressed("move_sprint"):
			current_speed = sprinting_speed
		else:
			current_speed = walking_speed

func handle_jump():
	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		velocity.y = jump_velocity

func apply_gravity(_delta):
		# Add the gravity.
	if not is_on_floor():
		var deaccell_ramp = lerpf(0, grav_multiplier, gravity_accel_ramp)
		velocity.y -= (gravity - deaccell_ramp) * _delta 	
		
func bunny_hop(_delta):
	if bunny:
		if Input.is_action_just_pressed("move_jump") and Input.is_action_pressed("move_forward"):
			print("Bunny!")
			var speedbonus = current_speed + bunny_multiplier
			var actual_speedbonus = lerpf(speedbonus, current_speed, bunny_deaccell)
			current_speed = actual_speedbonus

func handle_movement(_delta):
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	direction = lerp(direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), _delta * move_lerp_speed)
	
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
		
	move_and_slide()
	
