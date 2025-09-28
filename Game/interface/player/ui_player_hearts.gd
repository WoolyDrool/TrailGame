extends HBoxContainer

@export_category("Elements")
@export var heart1 : TextureRect # TODO 9/28/25: need to replace this with an array instead of hardcoded stuff but i cant be bothered rn
@export var heart2 : TextureRect
@export var heart3 : TextureRect
@export var filled_tex : Texture2D
@export var empty_tex : Texture2D
@export var idk_what_this_is_called : TextureRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.ui_update_player_health.connect(update_health_display)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_health_display(new_health : int):
	# TODO 9/28/25: need to replace this with more dynamic solution
	if new_health == 1:
		heart1.texture = filled_tex
		heart2.texture = empty_tex
		heart3.texture = empty_tex
	elif new_health == 2:
		heart1.texture = filled_tex
		heart2.texture = filled_tex
		heart3.texture = empty_tex
	elif new_health == 3:
		heart1.texture = filled_tex
		heart2.texture = filled_tex
		heart3.texture = filled_tex
