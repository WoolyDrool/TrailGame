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

var complete : bool

# Internal
@onready var mission_timer : Timer = $MissionTimer
@onready var timer_label : RichTextLabel = $MissionTimerLabel
var objectives_completed : int = 0
var mission_active : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !mission_timer:
		mission_timer = $MissionTimer 
	#GameManager.mission_start.connect(begin_mission)
	#GameManager.mission_add_score.connect(complete_objective)
	boundaries.visible = false
	print(objectives_in_mission)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if objectives_completed == objectives_in_mission:
		finish_mission()
	
func register_new_objective(amt : int):
	objectives_in_mission += amt
	#print_debug("Registered objective, total: ", objectives_in_mission)

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
	
func complete_objective(amt : int):
	objectives_completed += amt
	print_debug("Completed ", objectives_completed, " of ", objectives_in_mission, " objectives")
	complete = true
	if objectives_completed == objectives_in_mission:
		finish_mission()

func add_wrong_deposit(amt : int):
	mission_wrong_deposits += amt
	print_debug("Wrong Deposits: ", mission_wrong_deposits)

func finish_mission():
	boundaries.visible = false
	boundaries.use_collision = false
	area.complete_area_mission(self)
	GameManager.mission_end.emit(self)
	mission_active = false

func fail_mission():
	boundaries.visible = false
	boundaries.use_collision = false
	area.fail_area_mission(self)
	GameManager.mission_fail.emit(self)
	mission_active = false


func _on_mission_timer_timeout() -> void:
	print("called")
	if objectives_completed < objectives_in_mission:
		fail_mission()
		print("Mission Failed")
		print("Remaining Objectives: ", (objectives_in_mission - objectives_completed))
		# Do failure stuff
