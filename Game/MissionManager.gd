extends Node

# Mission Info
@export var mission_time : float 
@export var objectives_in_mission : int = 0
@export var wrong_deposits : int = 0

# Internal
@onready var mission_timer : Timer = $MissionTimer
@onready var timer_label : RichTextLabel = $MissionTimerLabel
var objectives_completed : int = 0
var mission_active : bool

signal update_time_remaining(new_time : float)

func _ready():
	if !mission_timer:
		mission_timer = $MissionTimer 
	GameManager.mission_start.connect(begin_mission)
	GameManager.mission_add_score.connect(complete_objective)
	GameManager.mission_add_wrongdeposit.connect(add_wrong_deposit)

func begin_mission():
	mission_timer.set_wait_time(mission_time)
	mission_timer.start()
	timer_label.text = ""
	mission_active = true
	pass

func _process(delta):
	if mission_active:
		timer_label.text = "%d:%0d" % [floor(mission_timer.time_left / 60), int(mission_timer.time_left) % 60]
	elif Input.is_action_just_pressed("tertiary"):
		GameManager.mission_start.emit()
		
# Done before mission start to register all objectives
func register_new_objective(amt : int):
	objectives_in_mission += amt

# Called when player deposits, chops wood etc.
func complete_objective(amt : int):
	objectives_completed += amt
	if objectives_completed == objectives_in_mission:
		complete_mission()

func _on_mission_timer_timeout():
	if objectives_completed > objectives_in_mission:
		print("Mission Failed")
		print("Remaining Objectives: ", (objectives_in_mission - objectives_completed))
		# Do failure stuff

func complete_mission():
	# Tally scores
	# Lock player controls
	# etc...
	print("Mission Succeeded")
	GameManager.mission_end.emit()
	pass

func add_wrong_deposit(amt : int):
	wrong_deposits += amt
	print_debug("Wrong Deposits: ", wrong_deposits)
