class_name RewardMenu
extends PanelContainer

@onready var _continue_button = $MarginContainer/VBoxContainer/BoxContainer/ContinueButton

@onready var score_label=$MarginContainer/VBoxContainer/ScoreLabel

func _on_continue_button_pressed() -> void:
	Global.goto_scene("res://ArenaChoice/arena_choice.tscn")

func _ready() -> void:
	var score=RunInfo.total_score
	score_label.text="Score: "+str(score)
	
