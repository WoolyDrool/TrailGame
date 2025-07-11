extends PlayerState

@export_category("Transitions")
@export var move_state : PlayerState
@export var jump_state : PlayerState
@export var fall_state : PlayerState

func process_input(_event : InputEvent) -> PlayerState:
	super(_event)
	return null

func process_physics(_delta : float) -> PlayerState:
	super(_delta)
	if movement_direction:
		return move_state
	
	if !player.is_on_floor():
		return fall_state
		
	#player.move_and_slide()
	
	if Input.is_action_just_pressed("move_jump"):
		return jump_state
	
	return null
