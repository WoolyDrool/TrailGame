extends Control


#region Main
@onready var completed_label = $MissionCompleteLabel
@onready var fail_label = $MissionFailLabel
@onready var score_label = $ScoreLabel

@onready var timer_label = $MissionTimerLabel
@onready var mission_timer : Timer = $MissionTimer
var counting : bool
#endregion

#region Pockets
@onready var pocket_left_fill = $HBoxContainer/LPocketBG/LPocketFill
@onready var pocket_right_fill = $HBoxContainer/RPocketBG/RPocketFill
@onready var pocket_left_garbnumb = $HBoxContainer/LPocketBG/LPocketTrash
@onready var pocket_left_recnumb = $HBoxContainer/RPocketBG/LPocketRecycle
@onready var pocket_right_garbnumb = $HBoxContainer/RPocketBG/RPocketTrash
@onready var pocket_right_recnumb = $HBoxContainer/RPocketBG/RPocketRecycle
#endregion

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.mission_start.connect(begin_mission_ui)
	GameManager.mission_end.connect(complete_mission_ui)
	GameManager.mission_fail.connect(fail_mission_ui)
	
	GameManager.ui_update_item_counts.connect(update_counts)
	GameManager.ui_update_score_count.connect(update_score)
	GameManager.ui_timer_start.connect(begin_ui_timer)
	
	completed_label.visible = false
	fail_label.visible = false
	timer_label.visible = false
	score_label.visible = false

func begin_mission_ui(mission : AreaMission):
	update_score(mission)
	timer_label.visible = true
	score_label.visible = true

func begin_ui_timer(time : float):
	counting = true
	#mission_timer.wait_time = time
	mission_timer.start(time)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if counting:
		timer_label.text = "0%d:%0d" % [floor(mission_timer.time_left / 60), int(mission_timer.time_left) % 60]
	pass

func update_counts():
	#trash_count_label.text = str("[center]Trash: ", MissionInventory.level_trash_count,"[/center]")
	#recycle_count_label.text = str("[center]Recycle: ", MissionInventory.level_recycle_count,"[/center]")
	
	pocket_left_fill.value = PocketManager.left_pocket_current
	pocket_right_fill.value = PocketManager.right_pocket_current
	
	# This is probably horribly innefficient
	# Too bad! 
	#pocket_left_garbnumb = str(PocketManager.left_pocket_trash)
	#pocket_left_recnumb.text = str(PocketManager.left_pocket_recycle)
	#pocket_right_garbnumb.text = str(PocketManager.right_pocket_trash)
	#pocket_right_recnumb.text = str(PocketManager.right_pocket_recycle)
	#trash_count_label.text = str(MissionInventory.level_trash_count)

func update_score(mission : AreaMission):
	var scr_as_percentage = int(round((float(mission.objectives_completed) / mission.objectives_in_mission) * 100))
	score_label.text = str("[center]", str(scr_as_percentage), "%[/center]")

func complete_mission_ui(mission : AreaMission):
	timer_label.visible = false
	score_label.visible = false
	completed_label.visible = true

func fail_mission_ui(mission : AreaMission):
	timer_label.visible = false
	score_label.visible = false
	fail_label.visible = true
