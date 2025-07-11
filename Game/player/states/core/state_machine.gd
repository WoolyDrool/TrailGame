class_name StateMachine
extends Node

@export var starting_state : State
@export var current_state : State

signal s_player_updateMouseState(has_mouse_control : bool)

# Initialize the state machine by giving each child state a reference to the
# player object it belongs to and enter the default starting_state
func init(parent: PlayerSMC) -> void:
	for child : PlayerState in get_children():
		child.player = parent
		child.mouse_sensitivity = GameManager.mouse_sensitivity
		child.move_speed = parent.default_movement_speed

	# Initialize to the default state
	change_state(starting_state)

# Change to the new state by first calling any exit logic on the current state
func change_state(new_state :  State) -> void:
	if current_state == new_state:
		push_error("Already in '", new_state, "', cannot be entered at this time")
		return	
	#if !new_state.can_be_entered:
		#push_error("State '", new_state, "' cannot be entered at this time")
		#return
	if current_state:
		current_state.exit()

	current_state = new_state
	current_state.enter()
	if current_state is PlayerState:
		s_player_updateMouseState.emit(current_state.has_mouse_control)
	
	print("Entered state: ", current_state)

# Pass through functions for the Player to call,
# handling state changes as needed
func process_physics(delta : float) -> void:
	var new_state = current_state.process_physics(delta)
	if new_state:
		change_state(new_state)

func process_input(event : InputEvent) -> void:
	var new_state = current_state.process_input(event)
	if new_state:
		change_state(new_state)

func process_frame(delta : float) -> void:
	var new_state = current_state.process_frame(delta)
	if new_state:
		change_state(new_state)
	
	
