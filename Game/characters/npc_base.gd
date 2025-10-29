@icon("res://App/editor icons/spr_ed_npc.png")
class_name NPCGeneric
extends Node3D

@export var dialogue_timeline : DialogicTimeline
@export var character : DialogicCharacter
@onready var anim_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_conversation():
	GameManager.player_seize_controls.emit()
	Dialogic.start(dialogue_timeline)
	Dialogic.timeline_ended.connect(end_conversation)

func end_conversation():
	GameManager.player_return_controls.emit()
