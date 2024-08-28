extends Node

# Player
var player_path : String = "res://Game/player/player.tscn"
var toggle_crouch : bool = false
var toggle_sprint : bool = false
signal move_player_to_position(newpos : Vector3)

# Control
signal player_enabled(bool)
signal player_control_enabled(bool)

# UI
signal ui_update_item_counts # Updates things things like pockets
signal ui_update_score_count(mission : AreaMission) # Updates the progress bar for each stage
signal ui_timer_start(time : float)

# Game Modes
signal change_gamemode(gm : GameMode)

# Game Mode - Missions
signal mission_start(mission : AreaMission)
signal mission_end(mission : AreaMission)
signal mission_fail(mission : AreaMission)
signal mission_add_score(score : int)
signal mission_add_wrongdeposit(amt : int)

# Missions - Areas
signal area_complete_area

# Scene Management
signal load_scene(path : String)
