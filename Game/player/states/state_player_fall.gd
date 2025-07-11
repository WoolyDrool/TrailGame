extends PlayerState

@export_category("Transitions")
@export var idle_state : PlayerState
@export var move_state : PlayerState
var direction : Vector3

func enter() -> void:
	super()

func exit() -> void:
	super()

func process_input(_event : InputEvent) -> PlayerState:
	super(_event)
	return null

func process_physics(_delta : float) -> PlayerState:
	super(_delta)
	
	if not player.is_on_floor():
		player.velocity.y -= gravity * _delta
	
	player.move_and_slide()
	
	if movement_direction:
		player.velocity.x = movement_direction.x * move_speed
		player.velocity.z = movement_direction.z * move_speed
	
	if player.is_on_floor():
		return idle_state
	return null

func process_frame(_delta : float) -> PlayerState:
	super(_delta)
	return null
