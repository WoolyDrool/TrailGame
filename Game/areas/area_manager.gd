class_name AreaManager
extends Node

@export_category("Area Information")
@export var area_name : String = "Default Area Name"
@export var missions_in_area = []
enum difficulty {EASY, MEDIUM, HARD}
@export var area_difficulty : difficulty

@export_category("Area Scoring")
@export var area_wrong_deposits : int = 0

var current_mission : AreaMission

#region Internal Variables
var missions_dict : Dictionary[String, AreaMission]

var area_completed : bool = false
signal complete_area
var missions_completed : int = 0

var failed_missions : int = 0
var final_area_score : float
#endregion

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.mission_attempt_to_start.connect(attempt_mission_start)
	
	#for mission in get_children():
		#if mission is AreaMission:
			#missions_in_area.append(mission.mission_name)
			#print("Added the mission ", mission.mission_name)
			#missions_dict[mission.mission_name.to_lower()] = mission
	print(missions_dict)

func attempt_mission_start(mission_name : String):
	current_mission = missions_dict.get(mission_name)
	
	if current_mission:
		current_mission.begin_mission()

func begin_area_mission(mission : AreaMission):
	if !current_mission:
		current_mission = mission 
	else:
		print_debug("There is already a mission active")

func complete_area_mission(mission : AreaMission):
	if current_mission == mission:
		current_mission = null
		missions_completed += 1
		final_area_score += mission.mission_score
		if missions_completed + failed_missions == missions_dict.size() && !area_completed:
			complete_area_final(self)
		missions_dict.erase(mission.mission_name)

func fail_area_mission(mission : AreaMission):
	if current_mission == mission:
		current_mission = null
		failed_missions += 1
	
func complete_area_final(area : AreaManager):
	print(final_area_score)
	area_completed = true
	GameManager.area_complete_area.emit(self)
	complete_area.emit()
	print(area_name, " Completed!")
