extends PlayerState

@export_category("Transitions")
@export var idle_state : PlayerState
@export var move_state : PlayerState

func enter() -> void:
	super()

func exit() -> void:
	super()

func process_input(_event : InputEvent) -> PlayerState:
	super(_event)
	return null

func process_physics(_delta : float) -> PlayerState:
	super(_delta)
	return null

func process_frame(_delta : float) -> PlayerState:
	super(_delta)
	return null