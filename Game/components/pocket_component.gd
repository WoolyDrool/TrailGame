extends Node

@export var max_pocket_size : int = 5

var left_pocket_trash : int = 0
var left_pocket_recycle : int = 0

var right_pocket_trash : int = 0
var right_pocket_recycle : int = 0

var left_pocket_current : int = 0
var right_pocket_current : int = 0

var left_pocket_mixed : bool = false
var right_pocket_mixed : bool = false

var total

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# false is left, true is right
func add_to_pockets(item : ObjectiveItem, leftright : bool):
	match item.type:
		item.item_type.TRASH:
			if !leftright:
				left_pocket_trash += 1
			else:
				right_pocket_trash += 1
			#print("Trash")
		item.item_type.RECYCLE:
			if !leftright:
				left_pocket_recycle += 1
			else:
				right_pocket_recycle += 1
			#print("Recycle")
	
	if !left_pocket_mixed:
		if left_pocket_trash > 0 && left_pocket_recycle > 0:
			left_pocket_mixed = true
			print("Left pocket mixed")
	if !right_pocket_mixed:
		if right_pocket_trash > 0 && right_pocket_recycle > 0:
			right_pocket_mixed = true
			print("Right pocket mixed")
	
	left_pocket_current = left_pocket_trash + left_pocket_recycle
	right_pocket_current = right_pocket_trash + right_pocket_recycle
	total = left_pocket_current + right_pocket_current
	#print("L trash: ", left_pocket_trash, " L rec: ", left_pocket_recycle)
	#print("R trash: ", right_pocket_trash, " R rec: ", right_pocket_recycle)

func empty_pocket(leftright : bool):
	if !leftright:
		left_pocket_trash = 0
		left_pocket_recycle = 0
		left_pocket_current = 0
	else:
		right_pocket_trash = 0
		right_pocket_recycle = 0
		right_pocket_current = 0
	
	GameManager.ui_update_item_counts.emit()
	total = left_pocket_current + right_pocket_current
	print("L Trash:", left_pocket_trash, " Recycle:", left_pocket_recycle)
	print("R Trash:", right_pocket_trash, " Recycle:", right_pocket_recycle)
	print("Pocket total: ", total)

#func empty_left_pocket():
	#print("Emptied left pocket")
	#left_pocket_current = 0
	#print("Pocket total: ", total)
#func empty_right_pocket():
	#print("Emptied right pocket")
	#right_pocket_current = 0
	#print("Pocket total: ", total)
