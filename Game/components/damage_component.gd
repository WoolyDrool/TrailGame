extends Area3D
var fired : bool = false
@export var damage_to_deal : int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		if !fired:
			GameManager.player_take_damage.emit(damage_to_deal)
			fired = true
		else:
			return
