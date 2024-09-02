extends Camera3D

class_name Frobber

@onready var raycaster : RayCast3D = $RayCast3D
@onready var frobber : ShapeCast3D = $Frobber
@export var frob_range : float = 2
var can_interact : bool
@export var col_to_select : InteractComponent
@export var tools : PlayerToolManager
var is_holding : bool

enum tool_state {EMPTY, PICKER, HATCHET, SHOVEL}
var cur_tool_state : tool_state

#region UI
@onready var crosshair = $ImmediateUI/Crosshair
@onready var interact_text : Label = $ImmediateUI/Crosshair/InteractText
@onready var modifier_text : Label = $ImmediateUI/Crosshair/ModifierText
@onready var append_text : Label = $ImmediateUI/Crosshair/AppendText
@onready var text_bg : ColorRect = $ImmediateUI/Crosshair/ColorRect
#endregion

func _ready() -> void:
	tools.on_tool_change.connect(update_held_tool_conditions)

func update_held_tool_conditions(current_tool : PlayerTool):
	if current_tool.toolName == "Empty Hands":
		cur_tool_state = tool_state.EMPTY
		print("Empty Hands")
	elif current_tool.toolName == "Picker":
		cur_tool_state = tool_state.PICKER
		print("Picker")
	elif current_tool.toolName == "Hatchet":
		cur_tool_state = tool_state.HATCHET
		print("Hatchet")
	elif current_tool.toolName == "Shovel":
		cur_tool_state = tool_state.SHOVEL
		print("Shovel")
	


func _process(delta):
	if col_to_select && is_instance_valid(col_to_select):
		can_interact = true
	else:
		can_interact = false
	frob()
	update_immediate_ui()

func frob():
	# todo 8/27/24 i think this is rescanning the object every frame. fine for now
	# but could very easily become a performance problem l8r
	
	#col_to_select = null
	var old_col
	
	if col_to_select != old_col:
		col_to_select = null
	
	# Check if the player is directly looking at an object and override the frobbing process
	if raycaster.is_colliding() && !col_to_select:
		if raycaster.get_collider() != null: # Important line to fix null instances
			if raycaster.get_collider().is_in_group("interactable"):
				col_to_select = raycaster.get_collider()
				old_col = col_to_select
				#print_debug("Raycast found ", col_to_select.get_parent().name)

	elif !raycaster.is_colliding() && frobber.is_colliding() && !col_to_select:
		# Check for the nearest collider in the ShapeCast3D
			for i in frobber.get_collision_count():
				if frobber.get_collider(i) != null: # Important line to fix null instances
					var test : CollisionObject3D = frobber.get_collider(i)
					# Check the distance of the points. Find the collision thats within frob_range
					if frobber.position.distance_to(test.position) < frob_range:
						if test.is_in_group("interactable"):
							col_to_select = test
							old_col = col_to_select
							#print_debug("Frobber found ", col_to_select.get_parent().name)

							break
	elif !raycaster.is_colliding() && !frobber.is_colliding() && col_to_select:
		col_to_select = null
		can_interact = false

func update_immediate_ui():
	if col_to_select:
		if interact_text.text == "":
			interact_text.text = col_to_select.interactText
			modifier_text.text = col_to_select.modifierText
			append_text.text = col_to_select.appendText
		
			interact_text.add_theme_color_override("Color", col_to_select.interactText_Color)
			modifier_text.add_theme_color_override("Color", col_to_select.modifierText_Color)
			append_text.add_theme_color_override("Color", col_to_select.appendText_Color)
		text_bg.visible = true
	else:
		interact_text.text = ""
		modifier_text.text = ""
		append_text.text = ""
		can_interact = false
		if text_bg.visible:
			text_bg.visible = false

func _unhandled_input(event: InputEvent) -> void:
	# Todo add a sorting filter for if the player is holding a specific tool or not
	if col_to_select && is_instance_valid(col_to_select):
		if cur_tool_state == tool_state.EMPTY:
			if event.is_action_pressed("interact"): #|| event.is_action_pressed("pocket_left") || event.is_action_pressed("pocket_right"):
				col_to_select.Interact(event)
				col_to_select = null
				update_immediate_ui()
		#elif cur_tool_state == tool_state.HATCHET:
			#if event.is_action_pressed("primary"): #|| event.is_action_pressed("pocket_left") || event.is_action_pressed("pocket_right"):
				#col_to_select.Interact(event)
				#col_to_select = null
				#update_immediate_ui()
		#elif cur_tool_state == tool_state.SHOVEL:
			#if event.is_action_pressed("primary"): #|| event.is_action_pressed("pocket_left") || event.is_action_pressed("pocket_right"):
				#col_to_select.Interact(event)
				#col_to_select = null
				#update_immediate_ui()
