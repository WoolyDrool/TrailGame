extends Node3D

class_name PlayerTool

var manager : PlayerToolManager
@export var toolName = "Default"
var isEquip : bool = false
var canPrimary : bool = true
var canSecondary : bool = true
var canTertiary : bool = true
@export var raycast_range = -2

var ray : RayCast3D
var ray_result : InteractComponent 
var frobber : Frobber
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
	
	# Scene tree needs to keep the hierarchy RayCast3D -> ToolCast -> Frobber -> ToolFrobber
	if !toolCast:
		get_parent().get_child(2)
	
	if !frobber:
		get_parent().get_child(4)
	
func _process(delta):
	pass

func tool_equip():
	isEquip = true
	visible = true
	set_process(true)

func tool_unequip():
	isEquip = false
	visible = false
	set_process(false)
	
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
