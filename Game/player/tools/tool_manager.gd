extends Node3D

class_name PlayerToolManager

# TOOL MANAGER
# Handles things like equipping/unequipping, input handling, and 

@export var player : Player
@export var cam_container : Node3D
@export var playerFrobber : Frobber

@export var default_tool : PlayerTool
@export var ray3d : RayCast3D
@export var toolName_label : Label 
@export var toolAmmo_label : Label

var current_tool : PlayerTool

var tool_array = []
var equip_index : int
var tool_selected : int = 0
var total_tools : int

var has_hatchet : bool = true
var has_shovel : bool = true
var prev_tween : Tween
var fade_tween : Tween

signal on_tool_change(tool : PlayerTool)

# Called when the node enters the scene tree for the first time.
func _ready():
	_ready_tools()
	switch_tool()
	toolName_label.text = str(default_tool.toolName)
	toolAmmo_label.text = ""
	pass # Replace with function body.

func _ready_tools():
	for t in get_children():
		if t is PlayerTool:
			t.manager = self
			t.ray = ray3d
			t.frobber = playerFrobber
			t.visible = false 
			t.set_process(false)
			current_tool = t # DebugOnly
			tool_array.append(t)
			print(t)
	current_tool = default_tool
	current_tool.tool_equip()			
			#total_tools += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var prev_selected = tool_selected
	_process_input()

	toolName_label.text = str(current_tool.toolName)
	
	if prev_selected != tool_selected:
		switch_tool()

func _process_input():
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if Input.is_action_just_pressed("primary") && current_tool.canPrimary:
			tool_primary()
		elif Input.is_action_just_pressed("secondary") && current_tool.canSecondary:
			tool_secondary()
		elif Input.is_action_just_pressed("tertiary") && current_tool.canTertiary:
			tool_tertiary()
		toolName_label.text = str(current_tool.toolName)
			
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
	
	# Keyboard input
	if Input.is_key_pressed(KEY_1): # Empty Hands
		tool_selected = 0
	elif Input.is_key_pressed(KEY_2): # Picker
		tool_selected = 1
	elif Input.is_key_pressed(KEY_3): # Hatchet
		tool_selected = 2
	elif Input.is_key_pressed(KEY_4): # Shovel
		tool_selected = 3
	
func switch_tool():
	equip_index = 0
	toolAmmo_label.text = ""
	if fade_tween != null:
		fade_tween.kill()
	
	if toolName_label.modulate != Color.WHITE:
		toolName_label.modulate = Color.WHITE
	
	for t in tool_array:
		if equip_index == tool_selected:
			t.tool_equip()
			t.set_process(true)
			current_tool = t
		else:
			t.tool_unequip()
			t.set_process(false)
		
		equip_index += 1
		
	on_tool_change.emit(current_tool)
	playerFrobber.immediate_ui.clear_immediate_ui()
	
	await get_tree().create_timer(2).timeout
	if fade_tween != null:
		fade_tween.kill()
		toolName_label.modulate = Color.WHITE
	fade_tween = create_tween()
	fade_tween.tween_property(toolName_label, "modulate", Color(255, 255, 255, 0), 1)


func tool_primary():
	current_tool._tool_primary()
	pass

func tool_secondary():
	current_tool._tool_secondary()
	pass
	
func tool_tertiary():
	current_tool._tool_tertiary()
	pass
