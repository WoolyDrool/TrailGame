extends Node

enum GAMEMODES {FREE_ROAM, GATHER, CUTSCENE}
@export var gamemode : GAMEMODES

func _ready() -> void:
	apply_gamemode()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func apply_gamemode():
	print("Applying Gamemodes")
	match gamemode:
		GAMEMODES.FREE_ROAM:
			GameManager.gamemode_enter_roam.emit()
			print("Current Gamemode: Free Roam")
		GAMEMODES.GATHER:
			GameManager.gamemode_enter_gather.emit()
			print("Current Gamemode: Gather")
