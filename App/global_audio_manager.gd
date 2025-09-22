extends AudioStreamPlayer

var global_player = "res://App/global_audio_player.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func play_sound(clip : AudioStream):
	var new_clip = load(global_player)
	new_clip.stream = clip
	pass
