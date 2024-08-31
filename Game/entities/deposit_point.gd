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
	
func deposit_from_pocket(leftright : bool):
	# Okay the flow for this is kinda fucked and could DEFINITELY be done better but it works for now
	# Its a lot of repeated logic
	match deposit_type:
		accepts.TRASH:
			if !leftright:
				# Left Pocket
				if PocketManager.left_pocket_current >= 1:
					if PocketManager.left_pocket_mixed:
						mission.add_wrong_deposit(PocketManager.left_pocket_recycle)
					mission.complete_objective(PocketManager.left_pocket_current)
			else:
				# Right Pocket
				if PocketManager.right_pocket_mixed:
					mission.add_wrong_deposit(PocketManager.right_pocket_recycle)
				mission.complete_objective(PocketManager.right_pocket_current)
		accepts.RECYCLE:
			if !leftright:
				# Left Pocket
				if PocketManager.left_pocket_current >= 1:
					if PocketManager.left_pocket_mixed:
						mission.add_wrong_deposit(PocketManager.left_pocket_trash)
					mission.complete_objective(PocketManager.left_pocket_current)
			else:
				# Right Pocket
				if PocketManager.right_pocket_current >= 1:
					if PocketManager.right_pocket_mixed:
						mission.add_wrong_deposit(PocketManager.right_pocket_trash)
					mission.complete_objective(PocketManager.right_pocket_current)
	PocketManager.empty_pocket(leftright)
	GameManager.ui_update_score_count.emit(mission)
	GameManager.ui_update_item_counts.emit()
		
func deposit_from_picker(item : ObjectiveItem):
	if item.type == item.item_type.TRASH:
		match deposit_type:
			accepts.TRASH:
				mission.complete_objective(1)
			accepts.RECYCLE:
				mission.add_wrong_deposit(1)
	elif item.type == item.item_type.RECYCLE:
		match deposit_type:
			accepts.TRASH:
				mission.add_wrong_deposit(1)
			accepts.RECYCLE:
				mission.complete_objective(1)
	
	GameManager.ui_update_score_count.emit(mission)
	GameManager.ui_update_item_counts.emit()
	
