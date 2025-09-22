extends PlayerTool

@export var max_items : int = 6
var current_items : int = 0
@onready var path : PathFollow3D = $Path3D/PathFollow3D
var item_container : Node3D
var can_pick : bool = true
var items = []
var adjusted_ratio
var is_looking_down : bool = true
@export var tool_manager : PlayerToolManager

func _get_nodes():
	item_container = $ItemContainer

func _process(delta: float) -> void:
	if isEquip:
		manager.toolAmmo_label.text = ("Items: " + str(current_items) + "/" + str(max_items))
	else:
		manager.toolAmmo_label.text = ""

func _tool_primary() -> void:
	#picker_frob()
	super()
	if current_items < max_items:
		if frobber.col_to_select && is_instance_valid(frobber.col_to_select):
			if frobber.col_to_select.is_in_group("pickable"):
				var picked_item = frobber.col_to_select.get_parent()
				picked_item.reparent(item_container)
				picked_item.freeze = true
				frobber.col_to_select.queue_free()
				adjusted_ratio = (max_items * path.progress)
				print(adjusted_ratio)
				path.progress_ratio += adjusted_ratio
				picked_item.position = path.position
				picked_item.rotation = path.rotation
				current_items += 1
				picked_item = null
				print("Found pickable item")

func _tool_secondary() -> void:
	super()
	if current_items <= max_items && current_items > 0:
		if frobber.col_to_select && is_instance_valid(frobber.col_to_select):
			if frobber.col_to_select.is_in_group("depositable"):
				frobber.col_to_select.get_parent().deposit_from_picker(item_container.get_child(current_items-1))
				item_container.get_child(current_items-1).queue_free()
				current_items -= 1
			pass

func _tool_tertiary() -> void:
	super()
	if tool_manager.player.is_looking_down and not tool_manager.player.has_picker_jumped:
		tool_manager.player.change_state(Player.PLAYER_STATES.PICKERJUMP)
