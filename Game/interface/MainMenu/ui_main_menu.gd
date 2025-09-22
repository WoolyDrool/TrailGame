extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_pressed() -> void:
	GameManager.load_scene.emit("res://Content/maps/level_1/map_hub.tscn")


func _on_quit_pressed() -> void:
	pass # Replace with function body.
