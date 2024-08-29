extends PlayerTool


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Actions
func _tool_primary() -> void:
	if frobber.col_to_select && is_instance_valid(frobber.col_to_select):
		if frobber.col_to_select.is_in_group("choppable"):
			frobber.col_to_select.GenericInteract()
