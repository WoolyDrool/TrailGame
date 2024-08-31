extends Node

class_name AreaMission

# Mission Info
@export var area : AreaManager
@export var mission_name : String = "Default Mission Name"
@export var mission_time : float 
@export var objectives_in_mission : int = 0
@export var mission_wrong_deposits : int = 0
@export var boundaries : CSGCombiner3D
@export var player_start_pos : Node3D
 
var complete : bool = false
var bonus_points : int
var completed_time_left : float

# Internal
@onready var mission_timer : Timer = $MissionTimer
var objectives_completed : int = 0
var mission_score : float
var mission_active : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !mission_timer:
		mission_timer = $MissionTimer 
	boundaries.visible = false
	print(mission_name, ", ", objectives_in_mission, ", ","Time Limit: ", str(mission_time))

#region Objectives
func register_new_objective(amt : int):
	objectives_in_mission += amt
	#print_debug("Registered objective, total: ", objectives_in_mission)

func complete_objective(amt : int):
	objectives_completed += amt
	print_debug("Completed ", objectives_completed, " of ", objectives_in_mission, " objectives")
	
	if objectives_completed == objectives_in_mission && !complete:
		finish_mission()

func add_wrong_deposit(amt : int):
	mission_wrong_deposits += amt
	print_debug("Wrong Deposits: ", mission_wrong_deposits)
#endregion

#region Missions
func begin_mission():
	boundaries.visible = true
	boundaries.use_collision = true
	area.begin_area_mission(self)
	mission_timer.start(mission_time)
	GameManager.move_player_to_position.emit(player_start_pos.global_position)
	GameManager.ui_timer_start.emit(mission_time)
	GameManager.mission_start.emit(self)
	mission_active = true
	pass

func finish_mission():
	completed_time_left = mission_timer.time_left
	mission_timer.stop()
	mission_active = false
	boundaries.visible = false
	boundaries.use_collision = false
	calculate_mission_score()
	area.complete_area_mission(self)
	GameManager.mission_end.emit(self)
	complete = true

func fail_mission():
	mission_timer.stop()
	mission_active = false
	boundaries.visible = false
	boundaries.use_collision = false
	calculate_mission_score()
	area.fail_area_mission(self)
	GameManager.mission_fail.emit(self)
	complete = true

func _on_mission_timer_timeout() -> void:
	if objectives_completed < objectives_in_mission:
		fail_mission()
		print("Mission Failed")
		print("Remaining Objectives: ", (objectives_in_mission - objectives_completed))
		# Do failure stuff
#endregion

#region Scoring
func calculate_mission_score():
	print(completed_time_left)
	var deposit_bonus = (objectives_completed * 3)
	var wrong_deposit_penalty = (mission_wrong_deposits * 0.25)
	var timer_remaining_bonus = (completed_time_left * 2)
	var style_bonus = (bonus_points * 0.5) * 3
	var calculated_score = (deposit_bonus + timer_remaining_bonus + style_bonus) - wrong_deposit_penalty
	mission_score = snappedf(calculated_score, 0.01)
	print(mission_score)
#endregion
