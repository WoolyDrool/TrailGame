extends Area3D

@export var area : AreaManager

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func open_mission_panel():
	for mission in area.missions_in_area:
		GameManager.ui_populate_mission_buttons.emit(mission)
	
	GameManager.ui_show_mission_panel.emit()

#func activate_mission_from_point():
	#mission.begin_mission()
	#pass
