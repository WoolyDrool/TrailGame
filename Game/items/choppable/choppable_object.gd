extends Area3D

@export var center_segment : ChoppedObject
@export var left_segment : ChoppedObject
@export var right_segment : ChoppedObject

@export var left_interact : InteractComponent
@export var right_interact : InteractComponent

var left_chopped : bool = false
var left_health : = 3
var right_chopped : bool = false
var right_health : = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	center_segment.disable_process()
	left_segment.disable_process()
	right_segment.disable_process()
	get_parent().get_parent().register_new_objective(3)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass

func generic_chop():
	print(left_health, left_chopped, right_health, right_chopped)
	if left_chopped && right_chopped:
		center_segment.reparent(get_parent().get_parent())
		center_segment.enable_process()
func on_chop_left():
	print("chopped left")
	left_health -= 1
	if left_health <= 0:
		left_segment.reparent(get_parent().get_parent())
		left_segment.enable_process()
		left_interact.queue_free()
		left_chopped = true
	generic_chop()
	pass

func on_chop_right():
	print("chopped right")
	right_health -= 1
	if right_health <= 0:
		right_segment.reparent(get_parent().get_parent())
		right_segment.enable_process()
		right_interact.queue_free()
		right_chopped = true
	generic_chop()
	pass
