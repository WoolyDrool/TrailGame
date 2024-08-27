extends Camera3D

@onready var raycaster : RayCast3D = $RayCast3D
@onready var frobber : ShapeCast3D = $Frobber
var can_interact : bool
var can_pocket : bool
var valid_target : bool
var x : InteractComponent
var col_to_select : InteractComponent
var is_holding : bool

var frob_rays = []

#region UI
@onready var crosshair = $Crosshair
@onready var interact_text : Label = $Crosshair/InteractTextLabel
@onready var modifier_text : Label = $Crosshair/InteractType
@onready var text_bg : ColorRect = $Crosshair/ColorRect
#endregion

func _ready() -> void:
	pass
	
func _process(delta):
	if frobber.is_colliding():
		for col in frobber.get_overlapping_areas():
			frob_rays[RayCast3D.new()]
		if x in frobber.get_overlapping_areas():		
			if can_interact && x != null:
				if x.is_in_group("interactable"):
					interact_text.text = x.interactText
					modifier_text.text = x.modifierText
					text_bg.visible = true
					can_interact = true
				else:
					can_interact = false
					
			if x.get_parent().is_in_group("pocketable"):
				can_pocket = true
				var objitem = x.get_parent() as ObjectiveItem
				match objitem.type:
					objitem.item_type.TRASH:
						modifier_text.text = "Trash"
						modifier_text.add_theme_color_override("font_color", Color.GREEN)
					objitem.item_type.RECYCLE:
						modifier_text.text = "Recycle"
						modifier_text.add_theme_color_override("font_color", Color.SKY_BLUE)
			else:
				can_pocket = false
	else:
		interact_text.text = ""
		modifier_text.text = ""
		if text_bg.visible:
			text_bg.visible = false
		x = null
	
	if can_interact && x != null:
		if Input.is_action_just_pressed("interact"):
			is_holding = Input.is_action_pressed("interact")
			x.Interact(is_holding)
			x = null
			can_interact = false
			
	if can_pocket:
		if Input.is_action_just_pressed("pocket_left"):
			if x.parent.is_in_group("deposit points"):
				x.get_parent().deposit_from_pocket(false)
			elif !x.get_parent().pocketable:
				return
			else:
				x.get_parent().on_pocket(false)
				x = null
				can_interact = false
		if Input.is_action_just_pressed("pocket_right"):
			if x.parent.is_in_group("deposit points"):
				x.get_parent().deposit_from_pocket(true)
			elif !x.get_parent().pocketable:
				return
			else:
				x.get_parent().on_pocket(true)
				x = null
				can_interact = false
