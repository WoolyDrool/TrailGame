extends Resource

class_name GameMode

@export var mode_name : String = "GameMode"

@export var player_enabled : bool = true
@export var player_control_enabled : bool = true

func enter_gamemode():
	pass

func exit_gamemode():
	pass

func gamemode_update(delta):
	pass
