extends State

@export var ps : PlayerState

func update(delta):
	# Determine movement speed
	if Input.is_action_pressed("move_crouch"):
		ps.current_speed = ps.crouching_speed
		ps.standing_collision.disabled = true
		ps.crouching_collision.disabled = false
	else:
		ps.standing_collision.disabled = false
		ps.crouching_collision.disabled = true
		if Input.is_action_pressed("move_sprint"):
			ps.current_speed = ps.sprinting_speed
		else:
			ps.current_speed = ps.walking_speed
	
	if Input.is_action_just_pressed("ui_cancel") && Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func phys_update(delta):
	# Add the gravity.
	if not ps.controller.is_on_floor():
		var deaccell_ramp = lerpf(0, ps.grav_multiplier, ps.gravity_accel_ramp)
		ps.controller.velocity.y -= (ps.gravity - ps.deaccell_ramp) * delta 

	# Handle Jump.
	if Input.is_action_just_pressed("move_jump") and ps.controller.is_on_floor():
		ps.controller.velocity.y = ps.jump_velocity
	
	if Input.is_action_just_pressed("move_jump") and Input.is_action_pressed("move_forward"):
		print("Bunny!")
		var speedbonus = ps.current_speed + ps.bunny_multiplier
		var actual_speedbonus = lerpf(speedbonus, ps.current_speed, ps.bunny_deaccell)
		ps.current_speed = ps.actual_speedbonus
		#velocity.x = direction.x + bunny_multiplier
		#velocity.z = direction.z + bunny_multiplier

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	ps.direction = lerp(ps.direction, (ps.controller.transform.basis * Vector3(ps.input_dir.x, 0, ps.input_dir.y)).normalized(), delta * ps.move_lerp_speed)
	
	if ps.direction:
		ps.ontroller.velocity.x = ps.direction.x * ps.current_speed
		ps.controller.velocity.z = ps.direction.z * ps.current_speed
	else:
		ps.controller.velocity.x = move_toward(ps.controller.velocity.x, 0, ps.current_speed)
		ps.controller.velocity.z = move_toward(ps.controller.velocity.z, 0, ps.current_speed)
	
	if(ps.input_dir.x > 0 || ps.input_dir.y > 0) and ps.controller.is_on_floor():
		transitioned.emit(self, "idle")
	elif (ps.input_dir.x > 0 || ps.input_dir.y > 0) and !ps.controller.is_on_floor():
		transitioned.emit(self, "jumping")
