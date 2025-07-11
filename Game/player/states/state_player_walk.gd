extends PlayerState

@export_category("Transitions")
@export var idle_state : PlayerState
@export var jump_state : PlayerState
@export var fall_state : PlayerState

var direction : Vector3

func process_input(_event : InputEvent) -> PlayerState:
	super(_event)
	return null

func process_physics(_delta : float) -> PlayerState:
	super(_delta)
	
	#direction = (player.transform.basis * Vector3(movement_vector.x, 0, movement_vector.y)).normalized() * _delta
	if movement_direction:	
		player.velocity.x = movement_direction.x * move_speed
		player.velocity.z = movement_direction.z * move_speed

	player.move_and_slide()
	
	if Input.is_action_just_pressed("move_jump"):
		return jump_state
		
	if not player.is_on_floor():
		return fall_state

	if movement_vector.x == 0 and movement_vector.y == 0:
		return idle_state
		
	return null
