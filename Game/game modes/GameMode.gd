extends Resource

class_name GameMode

@export var mode_name : String = "GameMode"

@export_category("Player Settings")
@export var player_enabled : bool = true
@export var player_control_enabled : bool = true
@export var player_tools_enabled : bool = false
@export var player_base_speed_modifier : float = 1

@export_category("UI Settings")
@export var player_hud_enabled : bool = true
@export var player_tool_hud_enabled : bool = false
@export var player_can_converse : bool = true

func enter_gamemode():
	pass

func exit_gamemode():
	pass

func gamemode_update(delta):
	pass
