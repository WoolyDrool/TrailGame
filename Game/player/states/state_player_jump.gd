extends PlayerState

@export_category("Transitions")
@export var idle_state : PlayerState
@export var move_state : PlayerState
@export var fall_state : PlayerState

var direction : Vector3

func enter() -> void:
	super()

func exit() -> void:
	super()

func process_physics(_delta : float) -> PlayerState:
	super(_delta)
	player.velocity.y = player.jump_height
	
	if movement_direction:
		player.velocity.x = movement_direction.x * move_speed
		player.velocity.z = movement_direction.z * move_speed	
	
	player.move_and_slide()
	
	if player.velocity.y > 0:
		return fall_state
	
	#if player.is_on_floor():
		#return idle_state
	return null
