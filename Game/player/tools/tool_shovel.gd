extends PlayerTool

@export var shovel_platform_obj : PackedScene
@export var shovel_platform_active : bool = false
@export var viewmodel : Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.tool_shovel_reclaim.connect(reclaim_shovel)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _tool_primary() -> void:
	if frobber.col_to_select && is_instance_valid(frobber.col_to_select):
		if frobber.col_to_select.is_in_group("diggable"):
			frobber.col_to_select.GenericInteract()

func _tool_tertiary() -> void:
	if !shovel_platform_active:
		if toolCast.is_colliding():
			print("placed shovel platform")
			var shovel_platform = shovel_platform_obj.instantiate()
			get_tree().root.add_child(shovel_platform)
			shovel_platform.position = Vector3(toolCast.get_collision_point().x, toolCast.get_collision_point().y + 0.5, toolCast.get_collision_point().z)
			shovel_platform_active = true
			canPrimary = false
			canSecondary = false
			canTertiary = false	
			viewmodel.visible = false
	
func reclaim_shovel():
	shovel_platform_active = false
	canPrimary = true
	canSecondary = true
	canTertiary = true
	viewmodel.visible = true
