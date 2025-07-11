extends State

@export_category("Transitions")
@export var state_transition : State

func enter() -> void:
	super()

func exit() -> void:
	super()

func process_input(_event : InputEvent) -> State:
	return null

func process_physics(_delta : float) -> State:
	return null

func process_frame(_delta : float) -> State:
	return null


