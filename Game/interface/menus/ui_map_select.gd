extends VBoxContainer

@export var level_to_load : String = "res://Content/maps/"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_debug_pressed() -> void:
	GameManager.load_scene.emit("res://Content/maps/map_debug.tscn")


func _on_office_pressed() -> void:
	GameManager.load_scene.emit("res://Content/maps/map_intro_office.tscn")


func _on_hub_pressed() -> void:
	GameManager.load_scene.emit("res://Content/maps/map_hub.tscn")
