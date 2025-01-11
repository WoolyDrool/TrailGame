extends Control

@onready var game = $"../../App/game.gd"

func _on_resume_pressed()-> void:
	game.pauseMenu()

func _on_quit_pressed()-> void:
	get_tree().quit()
