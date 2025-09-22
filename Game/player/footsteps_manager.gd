class_name FootstepsManager
extends RayCast3D

@export var audio_player : AudioStreamPlayer3D

@export var footsteps_normal : AudioStream
@export var interval : float = 1
@export var player : Player
@onready var timer = $FootstepsTimer
var can_play : bool = true
var pitch_variation : float = 0.1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audio_player.stream = footsteps_normal
	timer.wait_time = interval
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player.is_moving && can_play:
		handle_footsteps()
	pass

func handle_footsteps():
	can_play = false
	#pitch_variation = randf_range(pitch_variation, -pitch_variation)
	#audio_player.pitch_scale = pitch_variation
	audio_player.play()
	
func _on_footsteps_player_finished() -> void:
	timer.start()
	await timer.timeout
	can_play = true
