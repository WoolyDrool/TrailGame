extends Area3D

class_name InteractComponent

# This node will be attached to other nodes and will handle all the interaction handling
@export_group("HUD Information")
@export var interactText : String = "Default Message"
@export var modifierText : String = ""
@export var appendText : String = ""
@export_group("Connections")
@export var methodName : String
@export var usesSignal : bool = false
@export var signalName : String
@export var hitbox : HitboxComponent
var parent

# Called when the node enters the scene tree for the first time.
func _ready():
	# I don't know if this actually fixes anything but changing this line to get_node_3d instead of
	# get_node makes it not break when inside an inherited scene_change
	parent = get_parent_node_3d()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func Interact(is_holding : bool):
	if methodName:
		parent.call(methodName)
	elif !parent.has_method(methodName):
		print_debug("Parent doesn't have method ",  methodName)
	else:
		print_debug("No method to call!")
	
