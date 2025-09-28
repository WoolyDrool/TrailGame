class_name PlayerHealth
extends Node

@export var current_health : int
@export var maximum_health : int = 3
@export var invuln_time : float = 1
@export var dead : bool = false
@onready var invuln_timer = $InvulnTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_health = maximum_health
	GameManager.player_take_damage.connect(player_take_damage)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func player_take_damage(value : int):
	if invuln_timer.is_stopped():
		current_health -= value
		if current_health <= 0:
			player_death()
		else:
			GameManager.ui_update_player_health.emit(current_health)
			invuln_timer.start(invuln_time)
	else:
		print("Player was invulnverable")
		
func player_death():
	print("Player died!")
	#GameManager.player_death.emit()
	#GameManager.player_seize_controls.emit()
