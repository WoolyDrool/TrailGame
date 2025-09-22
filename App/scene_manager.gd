extends Node

@export var current_scene : Node

@export var player_spawn : PlayerSpawn
@export var transitioner : GlobalTransition

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.load_scene.connect(load_scene)
	GameManager.reload_current_scene.connect(reload_current)

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func reload_current():
	print("reloading current")
	var current_path = get_path_to(current_scene)
	load_scene(current_path)

func load_scene(path : String):
	if(ResourceLoader.exists(path)):
		transitioner.tween_out()
		await transitioner.transition_finished
		print("awaited transition")
		var new_scene = load(path).instantiate()
		current_scene.queue_free()
		current_scene = new_scene
		player_spawn = current_scene.find_child("PlayerSpawn")
		if !player_spawn:
			push_error("No PlayerSpawn in loaded scene!")
			return
		player_spawn.spawn_player()
		GameManager.player_spawned = true
		if current_scene.has_node("res://Game/game modes/area_gamemode.tscn"):
			current_scene.find_child("AreaGamemode").apply_gamemode()
		get_parent().add_child(new_scene)
		get_parent().scene_file_path
		transitioner.tween_in()
	else:
		print_debug("SCENE ", path, " IS NOT A VALID PATH")
	pass
