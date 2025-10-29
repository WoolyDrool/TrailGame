extends Control

@export var finalize_button : TextureButton
@export var submitted_name : String
enum CC_PLAYER_PRONOUNS {NONE, NONBINARY, MASCULINE, FEMININE, RANDOM}
@export var submitted_pronouns : CC_PLAYER_PRONOUNS
@export var interact_component : InteractComponent

signal character_creation_finish

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	finalize_button.visible = false
	interact_component.interacted.connect(open_character_creator)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func open_character_creator():
	self.visible = true
	$PaperRuffleSFX.play()
	GameManager.player_seize_controls.emit()

func check_if_info_valid() -> bool:
	if submitted_pronouns != CC_PLAYER_PRONOUNS.NONE && submitted_name != null:
		return true
	return false

func _on_name_entry_text_changed(new_text: String) -> void:
	submitted_name = new_text
	if check_if_info_valid():
		finalize_button.visible = true
	else:
		finalize_button.visible = false

func _on_pronouns_button_item_selected(index: int) -> void:
	match index:
		0:
			print("Masculine")
			submitted_pronouns = CC_PLAYER_PRONOUNS.MASCULINE
		1:
			print("Feminine")
			submitted_pronouns = CC_PLAYER_PRONOUNS.FEMININE
		2:
			print("Non-Binary")
			submitted_pronouns = CC_PLAYER_PRONOUNS.NONBINARY
		3:
			print("Random")
			submitted_pronouns = CC_PLAYER_PRONOUNS.RANDOM
	
	if check_if_info_valid():
		finalize_button.visible = true
	else:
		finalize_button.visible = false

func _on_finalize_button_toggled(toggled_on: bool) -> void:
	$StampSFX.play()
	$JuiceTimer.start()


func _on_juice_timer_timeout() -> void:
	self.visible = false
	character_creation_finish.emit()
	GameManager.player_return_controls.emit()
