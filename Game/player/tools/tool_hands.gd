extends PlayerTool

var holding : bool = false
@export var hold_point : Node3D
var held_object : Node3D
var held_object_interact : InteractComponent
var grab_speed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _tool_primary() -> void:
	if !holding:
		if frobber.col_to_select && is_instance_valid(frobber.col_to_select):
			if frobber.col_to_select.is_in_group("grabbable"):
				print("grabbed")
				held_object_interact = frobber.col_to_select
				var grabbed_obj = frobber.col_to_select.get_parent()
				held_object = grabbed_obj
				grabbed_obj = null
				held_object.freeze = true
				held_object.reparent(hold_point)
				held_object.position = hold_point.position
				held_object.rotation = hold_point.rotation
				held_object_interact.collision.disabled
				holding = true
				
func _tool_secondary() -> void:
	if holding:
		if held_object != null:
			print("threw")
			# First child in a grabbable object is RigidBody3D
			held_object.freeze = false
			var angle = manager.player.global_rotation.y
			held_object.apply_central_impulse(-manager.player.global_transform.basis.z.normalized() * 15 + Vector3(0,5,0))
			held_object.reparent(manager.player.get_parent())
			held_object_interact.collision.disabled = false
			held_object = null
			held_object_interact = null
			holding = false
