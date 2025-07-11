extends Node

@export var current_scene : Node

@export var player_spawn : PlayerSpawn

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.load_scene.connect(load_scene)

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_scene(path : String):
	if(ResourceLoader.exists(path)):
		var new_scene = load(path).instantiate()
		current_scene.queue_free()
		current_scene = new_scene
		player_spawn = current_scene.find_child("PlayerSpawn")
		if !player_spawn:
			push_error("No PlayerSpawn in loaded scene!")
			return
		player_spawn.spawn_player()
		if current_scene.has_node("res://Game/game modes/area_gamemode.tscn"):
			current_scene.find_child("AreaGamemode").apply_gamemode()
		get_parent().add_child(new_scene)
		get_parent().scene_file_path
	else:
		print_debug("SCENE ", path, " IS NOT A VALID PATH")
	pass
