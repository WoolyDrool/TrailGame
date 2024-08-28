extends Node3D

class_name PlayerTool

@export var toolName = "Default"
var isEquip : bool = false
var canPrimary : bool = true
var canSecondary : bool = true
var canTertiary : bool = true
@export var raycast_range = -2

var ray : RayCast3D
var ray_result : CollisionObject3D 
@export var toolCast : RayCast3D
@onready var primaryActionTimer = $PrimaryTimer
@onready var secondaryActionTimer = $SecondaryTimer
@onready var tertiaryActionTimer = $TertiaryTimer
var animPlayer : AnimationPlayer

@export var primaryActionCooldown : float
@export var secondaryActionCooldown : float
@export var tertiaryActionCooldown : float

func _ready():
	_get_nodes()

func _get_nodes():
	if primaryActionCooldown > 0:
		primaryActionTimer.wait_time = primaryActionCooldown
	if secondaryActionCooldown > 0:
		secondaryActionTimer.wait_time = secondaryActionCooldown
	if tertiaryActionCooldown > 0:
		tertiaryActionTimer.wait_time = tertiaryActionCooldown
	
	if !toolCast:
		get_parent().find_child("ToolRayCast3D")
	
func _process(delta):
	pass

func tool_equip(on : bool) -> void:
	print(toolName, " toggled ", on)
	if on:
		ray.target_position = Vector3(0, raycast_range, 0)
	
	self.visible = on
	self.set_process(on)

# Actions
func _tool_primary() -> void:
	canPrimary = false
	if primaryActionTimer:
		primaryActionTimer.start()

func _tool_secondary() -> void:
	canSecondary = false
	if secondaryActionTimer:
		secondaryActionTimer.start()

func _tool_tertiary() -> void:
	canTertiary = false
	if tertiaryActionTimer:
		tertiaryActionTimer.start()

func _on_primary_timeout():
	canPrimary = true
	pass # Replace with function body.


func _on_secondary_timeout():
	canSecondary = true
	pass # Replace with function body.


func _on_tertiary_timeout():
	canTertiary = true
	pass # Replace with function body.
