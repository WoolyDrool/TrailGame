extends Objective

class_name ObjectiveItem

@export var objective_worth : int = 1
@export var item_name : String
enum item_type {NONE, TRASH, RECYCLE, KEY}
@export var type : item_type
@export var pocketable : bool = true

func _ready():
	if !type == item_type.KEY:
		get_parent().get_parent().register_new_objective(objective_worth)
	
	$Interact.interactText = item_name

func on_pocket(leftright : bool):
	if type != item_type.NONE:
		if !leftright:
			if PocketManager.left_pocket_current <= PocketManager.max_pocket_size:
					PocketManager.add_to_pockets(self, leftright)
					queue_free()
		else:
			if PocketManager.right_pocket_current <= PocketManager.max_pocket_size:
					PocketManager.add_to_pockets(self, leftright)
					queue_free()
	else:
		print("Item does not have a type")
	GameManager.ui_update_item_counts.emit()
