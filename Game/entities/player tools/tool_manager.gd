extends Node3D

class_name PlayerToolManager

@export var default_tool : PlayerTool
var current_tool : PlayerTool

var equip_index : int
var tool_selected : int = 0
var total_tools : int
var tool_array = []

@export var ray3d : RayCast3D
@export var playerFrobber : Frobber
var has_hatchet : bool = true
var has_shovel : bool = true
@export var debuglabel : Label
@export var hand_container : Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	if !hand_container:
		hand_container = $HandContainer
	switch_tool()
	_ready_tools()
	debuglabel.text = str(default_tool.toolName)
	pass # Replace with function body.

func _ready_tools():
	for t in get_children():
		if t is PlayerTool:
			t.ray = ray3d
			t.frobber = playerFrobber
			t.visible = false
			t.set_process(false)
			current_tool = t # DebugOnly
			tool_array.append(t)
			print(t)
			
			#total_tools += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var prev_selected = tool_selected
	_process_input()

	debuglabel.text = str(current_tool.toolName)
	
	if prev_selected != tool_selected:
		switch_tool()

func _physics_process(delta: float) -> void:
	handle_sway()

func handle_sway():
	#rotate_y(deg_to_rad(-cam_container.rotation.x))
	#rotate_x(deg_to_rad(-cam_container.rotation.y))
	pass

func _process_input():
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if Input.is_action_just_pressed("primary") && current_tool.canPrimary:
			tool_primary()
		elif Input.is_action_just_pressed("secondary") && current_tool.canSecondary:
			tool_secondary()
		elif Input.is_action_just_pressed("tertiary") && current_tool.canTertiary:
			tool_tertiary()
		debuglabel.text = str(current_tool.toolName)
			
	# Toolbar Scrolling
	if Input.is_action_just_pressed("next_tool"):
		if tool_selected >= tool_array.size() - 1:
			tool_selected = 0
		else:
			tool_selected+=1
	elif Input.is_action_just_pressed("previous_tool"):
		if tool_selected <= 0:
			tool_selected = tool_array.size() - 1
		else:
			tool_selected-=1
	
func switch_tool():
	equip_index = 0
	
	for t in tool_array:
		if equip_index == tool_selected:
			t.tool_equip(true)
			t.set_process(true)
			current_tool = t
		else:
			t.tool_equip(false)
			t.set_process(false)
		
		equip_index += 1

func tool_primary():
	current_tool._tool_primary()
	pass

func tool_secondary():
	current_tool._tool_secondary()
	pass
	
func tool_tertiary():
	current_tool._tool_tertiary()
	pass
