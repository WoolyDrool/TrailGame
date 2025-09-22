class_name AreaMissionData
extends Resource

@export var mission_name : String = "Default Mission Name"
@export var player_start_pos : Vector3

@export_category("Main Data")
@export var mission_gold_time : float 
@export var mission_silver_time : float
@export var mission_bronze_time : float
@export var objectives_in_mission : int = 0
@export var mission_wrong_deposits : int = 0

@export_category("Post-Completed Data")
@export var objectives_completed : int
@export var time_taken : float
@export var has_completed_once : bool = false
enum MEDALS {DNF, BRONZE, SILVER, GOLD, PLATINUM}
@export var completed_medal :  MEDALS
enum LETTER_RANKS {D, C, B, A, S, SPLUS}
@export var completed_rank : LETTER_RANKS

func start_mission():
	pass
