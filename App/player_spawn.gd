@icon("res://App/editor icons/spr_ed_playerSpawn.png")
class_name PlayerSpawn
extends Node3D

var player_path : NodePath = "res://Game/player/player.tscn"
var current_player : Player
@export var cam_point : Node3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(0.25).timeout
	if !GameManager.player_spawned:
		spawn_player()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_player():
	if !current_player:
		if(ResourceLoader.exists(player_path)):
			var new_player : Player = load(player_path).instantiate()
			if current_player:
				current_player.queue_free()
			current_player = new_player
			get_parent().add_child(new_player)
			get_parent().scene_file_path
			current_player.position = position
			current_player.rotation = rotation
			await current_player
			current_player.cam_container.rotation.x = cam_point.rotation.x
			visible = false
