extends Area3D
@export var slowdown_percent : float = 0.65
var player : Player
var player_default_speed : float
var player_slowed_speed : float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player = body
		player_default_speed = player.walking_speed
		player_slowed_speed = player_default_speed * slowdown_percent
		player.overwrite_move_speed(player_slowed_speed)

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player.return_move_speed()
		player = null
