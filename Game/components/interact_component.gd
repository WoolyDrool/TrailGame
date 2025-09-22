extends Area3D

## The InteractComponent drives almost all player interactions in the game. It is the medium through which the players Frobber and the object being interacted with communicate

class_name InteractComponent

# This node will be attached to other nodes and will handle all the interaction handling
@export_group("HUD Information")
@export var interactText : String = "Default Message"
@export var interactText_Color : Color = Color.WHITE
@export var descriptorText : String = ""
@export var descriptorText_Color : Color
@export var contextText : String = ""
@export var contextText_Color : Color
@export_group("Connections")
@export var methodName : String
@export var usesSignal : bool = false
@export var signalName : String
@export var hitbox : HitboxComponent
var collision : CollisionShape3D
var parent

# Called when the node enters the scene tree for the first time.
func _ready():
	# I don't know if this actually fixes anything but changing this line to get_node_3d instead of
	# get_node makes it not break when inside an inherited scene_change
	parent = get_parent_node_3d()
	collision = get_child(0)

func Interact(action : InputEvent):
	if is_in_group("pocketable"):
		if action.is_action_pressed("pocket_left"):
			get_parent().on_pocket(false)
		if action.is_action_pressed("pocket_right"):
			get_parent().on_pocket(true)
	elif is_in_group("depositable"):
		if action.is_action_pressed("pocket_left"):
			get_parent().deposit_from_pocket(false)
		if action.is_action_pressed("pocket_right"):
			get_parent().deposit_from_pocket(true)
	elif is_in_group("choppable"):
		if action.is_action_pressed("primary"):
			parent.call(methodName)	
	elif is_in_group("diggable"):
		if action.is_action_pressed("primary"):
			parent.call(methodName)	
	elif is_in_group("interactable"):
		if action.is_action_pressed("interact"):
			parent.call(methodName)	
			
func GenericInteract():
	parent.call(methodName)
