extends Node

class_name AreaManager

@export var area_name : String = "Default Area Name"
enum difficulty {EASY, MEDIUM, HARD}
@export var area_difficulty : difficulty
var missions : Dictionary = {}
var missions_completed : int = 0
var current_mission : AreaMission
@export var area_wrong_deposits : int = 0
var failed_missions : int = 0
var area_completed : bool = false
var final_area_score : float
signal complete_area

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for mission in get_children():
		if mission is AreaMission:
			missions[mission.mission_name.to_lower()] = mission
	print(missions)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

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
		if missions_completed + failed_missions == missions.size() && !area_completed:
			complete_area_final(self)

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
