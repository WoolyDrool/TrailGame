extends Area3D

var mission : AreaMission
@export var player_start_pos : Transform3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_parent().is_in_group("missions"):
		mission = get_parent()
		print(mission.mission_name)
		$InteractComponent.interactText = "Begin Mission"
		$InteractComponent.modifierText = mission.mission_name
	else:
		print_debug("Mission Start Point is not the child of an AreaMission node")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func activate_mission_from_point():
	mission.begin_mission()
	pass
