class_name PlayerSaveData
extends Resource

@export var is_hardcore_save : bool = false

@export_category("Player Information")
@export var player_name : String = "Brad Default"
enum PLAYER_PRONOUNS {NONBINARY, MASCULINE, FEMININE, RANDOM}
@export var player_pronoun : PLAYER_PRONOUNS
@export var time_played : float

@export_category("Currency and Collectibles")
@export var money : int = 0

@export_category("Tools")
@export var has_pockets : bool = false
@export var has_picker : bool = false
@export var has_axe : bool = false
@export var has_shovel : bool = false

@export_category("Story")
@export var completed_tutorial : bool = false
