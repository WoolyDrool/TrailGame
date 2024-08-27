extends Node

@export var is_infinite : bool = false
@export var capacity : int = 20
enum accepts {TRASH, RECYCLE, BOTH}
@export var deposit_type : accepts
@export var mission : AreaMission

signal pocket_deposit(leftright : bool)
# Called when the node enters the scene tree for the first time.
func _ready():
	pocket_deposit.connect(deposit_from_pocket)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func deposit():
	match deposit_type:
		accepts.TRASH:
			#if MissionInventory.level_trash_count > 0:
				#MissionInventory.remove_item(true)
				#GameManager.mission_add_score.emit(1)
			pass
		accepts.RECYCLE:
			#if MissionInventory.level_recycle_count > 0:
				#MissionInventory.remove_item(false)
				#GameManager.mission_add_score.emit(1)
			pass
	
func deposit_from_pocket(leftright : bool):
	if !leftright:
		match deposit_type:
			accepts.TRASH:
				if PocketManager.left_pocket_recycle >= 1:
					mission.add_wrong_deposit(PocketManager.left_pocket_recycle)
				else:
					mission.complete_objective(PocketManager.left_pocket_current)
			accepts.RECYCLE:
				if PocketManager.left_pocket_trash >= 1:
					mission.add_wrong_deposit(PocketManager.left_pocket_trash)
				else:
					mission.complete_objective(PocketManager.left_pocket_current)
		
		#GameManager.mission_add_score.emit(PocketManager.left_pocket_current)	
	else:
		match deposit_type:
			accepts.TRASH:
				if PocketManager.right_pocket_recycle >= 1:
					mission.add_wrong_deposit(PocketManager.right_pocket_recycle)
				else:
					mission.complete_objective(PocketManager.right_pocket_current)
			accepts.RECYCLE:
				if PocketManager.left_pocket_trash >= 1:
					mission.add_wrong_deposit(PocketManager.right_pocket_trash)
				else:
					mission.complete_objective(PocketManager.right_pocket_current)
		#GameManager.mission_add_score.emit(PocketManager.right_pocket_current)
	
	PocketManager.empty_pocket(leftright)
	GameManager.ui_update_score_count.emit(mission)
	GameManager.ui_update_item_counts.emit()
	
#func deposit_both():
#	if is_infinite:
#		var sum : int = MissionInventory.get_sum()
#		GameManager.mission_add_score.emit(sum)
#		MissionInventory.remove_garbage(MissionInventory.level_trash_count)
#		GameManager.ui_update_score_count.emit()
		
