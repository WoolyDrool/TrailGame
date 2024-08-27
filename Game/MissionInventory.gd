extends Node

var level_trash_count : int = 0
var level_recycle_count : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func add_item(item : ObjectiveItem):
	match item.type:
		item.item_type.TRASH:
			level_trash_count += 1
			#print("Trash")
		item.item_type.RECYCLE:
			level_recycle_count += 1
			#print("Recycle")
		item.item_type.KEY: 
			pass
			#print("Key")
	#print_debug("Added item")

func remove_item(trash : bool):
	clamp(level_recycle_count, 0, 999)
	clamp(level_trash_count,  0, 999)
	
	if level_trash_count > 0 && trash:
		level_trash_count -= 1
	elif level_recycle_count > 0 && !trash:
		level_recycle_count -= 1
		
	GameManager.ui_update_item_counts.emit()	

# DEBUG ONLY (these are terrible methods)
# Rewrite with better solution later
#func remove_garbage(amount : int):
#	if level_trash_count > 0:
#		level_trash_count -= amount
#		clamp(level_trash_count, 0, 999)	
#		GameManager.ui_update_item_counts.emit()
#
#func remove_recycle(amount : int):
#	if level_recycle_count > 0:
#		level_recycle_count -= amount
#		clamp(level_recycle_count, 0, 999)
#		GameManager.ui_update_item_counts.emit()
#		

func get_sum():
	return level_recycle_count + level_trash_count

func remove_all():
	level_recycle_count = 0
	level_trash_count = 0
	pass
