extends Control

@onready var text_container = $BG/VBoxContainer
@onready var fps_label = $FPS
var fps_timer : float 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.debug_add_message.connect(add_label)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	fps_timer += delta
	if fps_timer > 0.5:
		fps_timer = 0
		fps_label.text = str(Engine.get_frames_per_second())

func add_label(message : String):
	var label : Label = Label.new()
	label.text = str(message)
	label.add_child(label)
