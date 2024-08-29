extends Node3D

var current_gamemode : GameMode

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.change_gamemode.connect(change_gamemode)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func change_gamemode(mode : GameMode):
	if mode == current_gamemode:
		return
	
	
