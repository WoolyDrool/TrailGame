class_name PlayerGamemodeManager
extends Node

@export var tool_manager : PlayerToolManager
@export var player_interface : PlayerInterface
@export var player_frobber : Frobber

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.gamemode_enter_roam.connect(enter_gamemode_roam)
	GameManager.gamemode_enter_gather.connect(enter_gamemode_gather)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func enter_gamemode_roam():
	print("Entering GameMode: Free Roam")
	tool_manager.set_process(false)
	pass

func exit_gamemode_roam():
	pass

func enter_gamemode_gather():
	tool_manager.set_process(true)
	pass

func exit_gamemode_gather():
	pass
