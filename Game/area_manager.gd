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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for mission in get_children():
		if mission is AreaMission:
			missions[mission.name.to_lower()] = mission
	pass # Replace with function body.


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
		
		if missions_completed == missions.size():
			# Do area complete stuff
			print(area_name, " Completed!")
			pass

func fail_area_mission(mission : AreaMission):
	if current_mission == mission:
		current_mission = null
		failed_missions += 1
	
