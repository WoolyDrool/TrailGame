extends CharacterBody3D

class_name Player

enum PLAYER_STATES {IDLE, WALKING, JUMPING, FALLING, TOUCHDOWN, CROUCHING, STANDINGUP, MENU, CONVERSATION, CUTSCENE, TELEPORTING, PICKERJUMP}
@export var player_state : PLAYER_STATES

# Nodes
@export var cam_container : Node3D
@onready var camera_phantom : PhantomCamera3D = $PhantomCamera3D
@onready var default_phantom_camera_target = $CamContainer
@onready var standing_collision = $StandingCollision
@onready var crouching_collision = $CrouchingCollision
@onready var ceiling_check = $CeilingCheck
@onready var health_manager = $PlayerHealthManager
@onready var debug_label = $DebugUI/RichTextLabel
@onready var debug_label_2 = $DebugUI/RichTextLabel2
@onready var stairs_ahead_raycast = $CamContainer/StairsAheadRayCast3D
@onready var stairs_below_raycast = $CamContainer/StairsBelowRayCast3D
@onready var immediate_ui = $CamContainer/Camera3D/ImmediateUI

@export_category("Mouse Look")
@export var mouse_sens : float = 0.4

@export_category("Gamepad Look")
@export var controller_look_sens : float = 0.5

@export_category("Headbob")
@export var use_headbob : bool = true
@export var headbob_amount : float = 0.04
@export var headbob_frequency : float = 2.4
@export var headbob_time : float 

# Movement
@export_category("Main Movement")
@export var walking_speed : float  = 5
@export var sprinting_speed : float  = 8
@export var ground_accel : float = 14
@export var ground_decel : float = 10 	# For the quake style movement, accel is 14, decel is 10, friction is 6
@export var ground_friction : float = 6

@export_category("Jumping and Air Movement")
@export var jump_velocity : float  = 4.5
@export var air_cap : float = 0.85
@export var air_accel : float = 800
@export var air_move_speed : float = 500

@export_category("Crouching")
@export var crouching_speed : float  = 2.5
@export var crouch_transition_speed : float = 0.55
@export var stand_transition_speed : float = 0.2

@export_category("Stairs")
@export var max_step_height : float = 0.5

#region Internal Variables
var prev_velocity : float
var current_speed : float = 5.0

var previous_state : PLAYER_STATES

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var input_dir
var wish_dir
var direction = Vector3.ZERO

var overwriting_speed : bool = false
var can_move : bool = true
var can_use_mouse : bool = true
var was_on_floor : bool = true
var has_picker_jumped : bool = false
var is_looking_down : bool = false
var cur_controller_look : Vector2

var fall_damage_threshhold : float = -20

var crouch_tween : Tween
var stand_tween : Tween
var default_cam_height = Vector3(0, 1, 0)
var crouched_cam_height = Vector3(0, 0, 0)

var snapped_to_stairs_last_frame : bool = false
var last_frame_was_on_floor = -INF # Spooky infinity

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
	immediate_ui.visible = false

func return_controls():
	can_move = true
	can_use_mouse = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	immediate_ui.visible = true
	
func teleport_player(newpos : Vector3):
	self.position = newpos
	pass

#func move_player_camera(new_target : Vector3):
	#if !can_move and !can_use_mouse:
		#camera_phantom.look_at_target = new_target
	#else:
		#push_error("Attempted to move camera while player has control")
#
#func reset_player_camera(new_target : Vector3):
	#if !can_move and !can_use_mouse:
		#camera_phantom.look_at_target = default_phantom_camera_target
	#else:
		#push_error("Attempted to move camera while player has control")

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

#region State Machine
func change_state(new_state : PLAYER_STATES) -> void:
	if !can_move:
		return
	if new_state == player_state:
		return
	
	previous_state = player_state
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
		PLAYER_STATES.CROUCHING:
			state_crouch(_delta)
			debug_label.text = str("state: Crouching")
		PLAYER_STATES.STANDINGUP:
			state_standup(_delta)
			debug_label.text = str("state: Standing Up")
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

#region States
func state_idle(_delta):
	if not is_on_floor():
		change_state(PLAYER_STATES.FALLING)	
	handle_movement_input()
	if input_dir.length() > 0:
		change_state(PLAYER_STATES.WALKING)	
	handle_jump_input()
	handle_crouch_input()
	handle_movement(_delta)

func state_walk(_delta):
	#print("in walking state")
	handle_movement_input()
	handle_movement(_delta)
	handle_jump_input()
	handle_crouch_input()
	if not is_on_floor():
		change_state(PLAYER_STATES.FALLING)	
	if input_dir.length() <= 0:
		change_state(PLAYER_STATES.IDLE)

func state_jump(_delta):
	#print("in jumping state")
	handle_movement_input()
	handle_movement(_delta)
	handle_jump_input()
	if velocity.y < jump_velocity:
		change_state(PLAYER_STATES.FALLING)

func state_pickerJump(_delta):
	has_picker_jumped = true
	handle_movement_input()
	handle_movement(_delta)
	velocity.y = jump_velocity * 2
	if velocity.y < jump_velocity * 2:
		change_state(PLAYER_STATES.FALLING)

func state_crouch(_delta):
	handle_movement_input()
	handle_crouch_input()
	handle_movement(_delta)
	handle_jump_input()
	standing_collision.disabled = true
	crouching_collision.disabled = false

func state_standup(_delta):
	handle_movement_input()
	handle_crouch_input()
	handle_movement(_delta)
	handle_jump_input()
	change_state(PLAYER_STATES.IDLE)
	standing_collision.disabled = false
	crouching_collision.disabled = true

func state_falling(_delta):
	#handle_crouch_input()
	handle_movement_input()
	handle_movement(_delta)
	
	#print("in falling state")
	if is_on_floor():
		change_state(PLAYER_STATES.TOUCHDOWN)

func state_touchdown(delta):
	print("touched down with a velocity of ", prev_velocity)
	if prev_velocity <= fall_damage_threshhold:
		print("player died from fall damage!")
		GameManager.player_death.emit()
		seize_controls()
	else:
		print("safely landed")
		has_picker_jumped = false
		handle_jump_input()
		if velocity.length() > 0:
			change_state(PLAYER_STATES.WALKING)
		else:
			change_state(PLAYER_STATES.IDLE)

func state_conversation():
	pass
#endregion

#region Transformation Functions
func handle_movement_input():
	input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	wish_dir = transform.basis * Vector3(input_dir.x, 0, input_dir.y).normalized()

func handle_jump_input():
	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		velocity.y = jump_velocity
		change_state(PLAYER_STATES.JUMPING)

func handle_crouch_input():
	if Input.is_action_pressed("move_crouch"):
		if player_state != PLAYER_STATES.CROUCHING:
			change_state(PLAYER_STATES.CROUCHING)
			if crouch_tween != null:
				crouch_tween.kill()
			crouch_tween = create_tween()
			crouch_tween.tween_property(camera_phantom, "position", crouched_cam_height, crouch_transition_speed)
	elif Input.is_action_just_released("move_crouch"):
		if !ceiling_check.is_colliding():
			if player_state == PLAYER_STATES.CROUCHING:
				change_state(PLAYER_STATES.STANDINGUP)
				if crouch_tween != null:
					crouch_tween.kill()
				crouch_tween = create_tween()
				crouch_tween.tween_property(camera_phantom, "position", default_cam_height, stand_transition_speed)
		else:
			return
	elif !Input.is_action_pressed("move_crouch"):
		if !ceiling_check.is_colliding():
			if player_state == PLAYER_STATES.CROUCHING:
				change_state(PLAYER_STATES.STANDINGUP)
				if crouch_tween != null:
					crouch_tween.kill()
				crouch_tween = create_tween()
				crouch_tween.tween_property(camera_phantom, "position", default_cam_height, stand_transition_speed)

#region Stairs
# These are direct calls to the PhysicsServer. Scary :-(
# Fun fact: the server only uses global coordinates
func _run_body_test_motion(from : Transform3D, motion : Vector3, result = null) -> bool:
	if not result : result = PhysicsTestMotionResult3D.new()
	var params = PhysicsTestMotionParameters3D.new()
	params.from = from
	params.motion = motion
	return PhysicsServer3D.body_test_motion(self.get_rid(), params, result)

func _snap_down_to_stairs_check() -> void:
	var did_snap = false
	var floor_below : bool = stairs_below_raycast.is_colliding() and not is_surface_too_steep(stairs_below_raycast.get_collision_normal())
	var was_on_floor_last_frame = Engine.get_physics_frames() - last_frame_was_on_floor == 1
	
	if not is_on_floor() and velocity.y <= 0 and (was_on_floor_last_frame or snapped_to_stairs_last_frame) and not floor_below:
		var body_test_result = PhysicsTestMotionResult3D.new()
		if _run_body_test_motion(self.global_transform, Vector3(0, -max_step_height, 0), body_test_result):
			var translate_y = body_test_result.get_travel().y
			position.y += translate_y
			apply_floor_snap()
			did_snap = true
			
	snapped_to_stairs_last_frame = did_snap

# This function is straight up indecipherable to me but the youtube man said it would work
# Shout out Majikayo Games
func _snap_up_to_stairs_check(_delta) -> bool:
	if not is_on_floor() and not snapped_to_stairs_last_frame: return false
	var expected_move_motion = self.velocity * Vector3(1,0,1) * _delta
	var step_pos_with_clearance = self.global_transform.translated(expected_move_motion * Vector3(0,max_step_height * 2, 0))
	var down_check_result = PhysicsTestMotionResult3D.new()
	
	# Actually evil series of if statements here
	if (_run_body_test_motion(step_pos_with_clearance, Vector3(0, -max_step_height * 2, 0), down_check_result)
	and (down_check_result.get_collider().is_class("StaticBody3D") or down_check_result.get_collider().is_class("CSGShape3D"))):
		var step_height = ((step_pos_with_clearance.origin + down_check_result.get_travel()) - self.global_position).y
		if step_height > max_step_height or step_height <= 0.01 or (down_check_result.get_collision_point() - self.global_position).y > max_step_height:
			return false
		stairs_ahead_raycast.global_position = down_check_result.get_collision_point() * Vector3(0, max_step_height, 0) + expected_move_motion.normalized() * 0.1
		stairs_ahead_raycast.force_raycast_update()
		if stairs_ahead_raycast.is_colliding() and not is_surface_too_steep(stairs_ahead_raycast.get_collision_normal()):
			self.global_position = step_pos_with_clearance.origin + down_check_result.get_travel()
			apply_floor_snap()
			snapped_to_stairs_last_frame = true
			return true
	return false
#endregion

func _handle_ground_physics(_delta) -> void:
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
	
	if use_headbob:
		if player_state != PLAYER_STATES.CROUCHING:
			_headbob_effect(_delta)

#region Surfing
func clip_velocity(normal : Vector3, overbounce : float, delta : float) -> void:
	var backoff = velocity.dot(normal) * overbounce
	if backoff >= 0: return
	
	var change = normal * backoff
	velocity -= change
	
	var adjust = velocity.dot(normal)
	if adjust < 0:
		velocity -= normal * adjust

func is_surface_too_steep(normal : Vector3) -> bool:
	return normal.angle_to(Vector3.UP) > self.floor_max_angle
#endregion

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
	
	# Enables surf
	if is_on_wall():
		if is_surface_too_steep(get_wall_normal()):
			motion_mode = CharacterBody3D.MOTION_MODE_FLOATING
		else:
			motion_mode = CharacterBody3D.MOTION_MODE_GROUNDED
		clip_velocity(get_wall_normal(), 1, _delta)

func handle_movement(_delta):
	if is_on_floor():
		last_frame_was_on_floor = Engine.get_physics_frames()
	
	if is_on_floor():
		_handle_ground_physics(_delta)
	else: 
		_handle_air_physics(_delta)
	
	if not _snap_up_to_stairs_check(_delta):
		# This function wraps move_and_slide because it manually moves the global_position of the controller
		# Doing otherwise would mess with the players velocity and mess up the black magic calculations
		move_and_slide()
		_snap_down_to_stairs_check()

func overwrite_move_speed(overwrite_speed : float):
	current_speed = overwrite_speed
	overwriting_speed = true

func return_move_speed():
	current_speed = walking_speed
	overwriting_speed = false

func determine_move_speed():
	if !overwriting_speed:
		# Determine movement speed
		if Input.is_action_pressed("move_crouch"):
			current_speed = crouching_speed
		else:
			if Input.is_action_pressed("move_sprint"):
				current_speed = sprinting_speed
			else:
				current_speed = walking_speed

func _headbob_effect(_delta):
	headbob_time += _delta * velocity.length()
	camera_phantom.transform.origin = Vector3(
		cos(headbob_time * headbob_frequency * 0.5) * headbob_amount,
		default_cam_height.y + sin(headbob_time * headbob_frequency) * headbob_amount,
		0
	)
#endregion
