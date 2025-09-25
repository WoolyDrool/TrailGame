extends Node

# Controls
var mouse_sensitivity : float = 0.4
var controller_enabled : bool = false

# Player
var player_path : String = "res://Game/player/player.tscn"
var toggle_crouch : bool = false
var toggle_sprint : bool = false

# Tools
signal tool_shovel_reclaim

# Control
signal player_enabled(bool)
signal player_control_enabled(bool)
signal player_seize_controls
signal player_return_controls
signal player_show_mouse(bool)
signal player_move_to_position(newpos : Vector3)
signal player_death

# UI
signal ui_update_item_counts # Updates things things like pockets
signal ui_update_score_count(mission : AreaMission) # Updates the progress bar for each stage
signal ui_timer_start(time : float)
signal ui_update_time_taken(time_taken : float)
signal ui_show_mission_panel
signal ui_hide_mission_panel
signal ui_populate_mission_buttons(missionName : String)

# Game Modes
signal change_gamemode(gm : GameMode)
signal gamemode_enter_roam
signal gamemode_exit_roam
signal gamemode_enter_gather
signal gamemode_exit_gather

# Game Mode - Missions
signal mission_start(mission : AreaMission)
signal mission_attempt_to_start(mission_name : String)
signal mission_end(mission : AreaMission)
signal mission_fail(mission : AreaMission)
signal mission_add_score(score : int)
signal mission_add_wrongdeposit(amt : int)
var mission_time_taken : float

# Missions - Areas
signal area_complete_area(area : AreaManager)

# Scene Management
signal load_scene(path : String)
signal load_scene_without_player(path : String)
signal reload_current_scene
var player_spawned : bool

# Debug
signal debug_add_message(message : String)
