class_name PlayerUIMainGameplay
extends PlayerUIPanel

@export_category("Main Mission Elements")
@export var mission_completed_label : Label
@export var mission_score_label : Label
@export var mission_time_label : Label
@export var mission_objectives_remaining_label : Label

@export_category("Pocket Elements")
@export var pocket_container : Container
@export var pocket_left_fill : TextureProgressBar
@export var pocket_right_fill : TextureProgressBar

@export_category("Area Elements")
@export var area_label : Label
@export var final_score_label : Label

func enter_panel() -> void:
	super()
	# Connect signals
	GameManager.mission_start.connect(populate_elements)
	GameManager.ui_update_item_counts.connect(update_elements)

func process_panel(_delta) -> void:
	super(_delta)
	mission_time_label.text = str( snappedf(GameManager.mission_time_taken, 0.1))

func exit_panel() -> void:
	GameManager.mission_start.disconnect(populate_elements)
	GameManager.ui_update_item_counts.disconnect(update_elements)
	super()

func populate_elements(mission : AreaMission):
	pass

func update_elements():
	pocket_left_fill.value = PocketManager.left_pocket_current
	pocket_right_fill.value = PocketManager.right_pocket_current
